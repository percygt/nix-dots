{
  config,
  lib,
  pkgs,
  options,
  ...
}:
let
  inherit (lib) mkOption mkEnableOption;
  supportedBrowsers = [
    "chromium"
    # "brave-nightly"
    "brave"
  ];
  webappModule = mkOption {
    default = { };
    type =
      with lib.types;
      attrsOf (submodule {
        options = {
          enable = mkEnableOption "webapp";
          url = mkOption {
            type = str;
            description = "The URL of the webapp to launch.";
          };

          commandLineArgs = mkOption {
            type = listOf str;
            default = [ ];
            description = "Extra args to launch Brave with.";
          };

          # Copied from xdg.desktopEntries, with slight modification for default settings
          name = mkOption {
            type = nullOr str;
            default = null;
            description = "Specific name of the application. Defaults to the capitalized attribute name.";
          };

          mimeType = mkOption {
            description = "The MIME type(s) supported by this application.";
            type = nullOr (listOf str);
            default = [
              "text/html"
              "text/xml"
              "application/xhtml_xml"
            ];
          };

          # Copied verbatim from xdg.desktopEntries.
          genericName = mkOption {
            type = nullOr str;
            default = null;
            description = "Generic name of the application.";
          };

          comment = mkOption {
            type = nullOr str;
            default = null;
            description = "Tooltip for the entry.";
          };

          categories = mkOption {
            type = nullOr (listOf str);
            default = null;
            description = "Categories in which the entry should be shown in a menu.";
          };

          icon = mkOption {
            type = nullOr (either str path);
            default = null;
            description = "Icon to display in file manager, menus, etc.";
          };

          prefersNonDefaultGPU = mkOption {
            type = nullOr bool;
            default = null;
            description = ''
              If true, the application prefers to be run on a more
              powerful discrete GPU if available.
            '';
          };
        };
      });
    description = "Websites to create special site-specific Brave instances for.";
  };

  webappConfig =
    browser:
    let
      inherit (builtins) stringLength substring;
      inherit (lib.attrsets) mapAttrs filterAttrs;
      inherit (lib.strings) concatStringsSep toUpper;
    in
    {
      xdg.desktopEntries = mapAttrs (name: cfg: {
        inherit (cfg) prefersNonDefaultGPU;
        name =
          if cfg.name == null then
            (toUpper (substring 0 1 name)) + (substring 1 (stringLength name) name)
          else
            cfg.name;

        startupNotify = true;
        terminal = false;
        type = "Application";

        exec = concatStringsSep " " (
          [
            "${lib.getExe config.programs.${browser}.package}"
            "--app=${cfg.url}"
            "--profile-directory=WebApp-${name}"
          ]
          ++ config.programs.${browser}.commandLineArgs
          ++ [ "%U" ]
        );

        settings = {
          X-MultipleArgs = "false"; # Consider enabling, don't know what this does
          StartupWMClass = "WebApp-${name}";
        };
      }) (filterAttrs (_: webapp: webapp.enable) config.programs.${browser}.webapps);
    };
in
{
  options.programs = {
    chromium.webapps = webappModule;
    brave.webapps = webappModule;
    brave-nightly = options.programs.brave // {
      package = lib.mkOption {
        visible = false;
        type = lib.types.package;
        defaultText = lib.literalExpression "pkgs.brave-nightly";
        description = "The Brave Browser Nightly package to use.";
        default = pkgs.brave-nightly;
      };
    };
  };

  config =
    let
      cfg = config.programs.brave-nightly;
      configDir = "${config.xdg.configHome}/BraveSoftware/Brave-Browser-Nightly";
      extensionJson =
        ext:
        assert ext.crxPath != null -> ext.version != null;
        with builtins;
        {
          name = "${configDir}/External Extensions/${ext.id}.json";
          value.text = toJSON (
            if ext.crxPath != null then
              {
                external_crx = ext.crxPath;
                external_version = ext.version;
              }
            else
              {
                external_update_url = ext.updateUrl;
              }
          );
        };

      dictionary = pkg: {
        name = "${configDir}/Dictionaries/${pkg.passthru.dictFileName}";
        value.source = pkg;
      };

      package =
        if cfg.commandLineArgs != [ ] then
          cfg.package.override {
            commandLineArgs = lib.concatStringsSep " " cfg.commandLineArgs;
          }
        else
          cfg.package;
    in
    lib.mkMerge (
      (map webappConfig supportedBrowsers)
      ++ [
        (lib.mkIf cfg.enable {
          home.packages = [ package ];
          home.file = lib.listToAttrs (
            (map extensionJson cfg.extensions) ++ (map dictionary cfg.dictionaries)
          );
        })
      ]
    );
}

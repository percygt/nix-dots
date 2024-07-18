{ config, lib, ... }:
let
  inherit (builtins) stringLength substring;
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.attrsets) mapAttrs filterAttrs;
  inherit (lib.strings) concatStringsSep toUpper;
in
{
  options.programs.chromium.webapps = mkOption {
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

  config = {
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
          "${lib.getExe config.programs.chromium.package}"
          "--app=${cfg.url}"
          "--profile-directory=WebApp-${name}"
        ]
        ++ cfg.commandLineArgs
        ++ [ "%U" ]
      );

      settings = {
        X-MultipleArgs = "false"; # Consider enabling, don't know what this does
        StartupWMClass = "WebApp-${name}";
      };
    }) (filterAttrs (_: webapp: webapp.enable) config.programs.chromium.webapps);
  };
}

{
  pkgs,
  config,
  lib,
  ...
}:
let
  g = config._global;
  moduleSwaync = "${g.flakeDirectory}/desktop/sway/swaync";
  c = config.modules.themes.colors.withHashtag;
  f = config.modules.fonts.app;
  i = config.modules.fonts.icon;
  extraPackages =
    g.system.envPackages
    ++ (with pkgs; [
      foot
    ]);
  swayncWithExtraPackages =
    pkgs.runCommand "swaync"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
        meta.mainProgram = "swaync";
      }
      ''
        makeWrapper ${pkgs.swaynotificationcenter}/bin/swaync $out/bin/swaync --prefix PATH : ${lib.makeBinPath extraPackages}
        makeWrapper ${pkgs.swaynotificationcenter}/bin/swaync-client $out/bin/swaync-client --prefix PATH : ${lib.makeBinPath extraPackages}
      '';
in
{
  services.swaync = {
    enable = true;
    package = swayncWithExtraPackages;
  };

  xdg.configFile = {
    "swaync/config.json".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${moduleSwaync}/config.json"
    );
    "swaync/style.css".source = config.lib.file.mkOutOfStoreSymlink "${moduleSwaync}/style.css";
    "swaync/nix.css".text =
      # css
      ''
        @define-color bg                  ${c.base00};
        @define-color bg-alt              ${c.base02};
        @define-color grey                ${c.base03};
        @define-color grey-alt            ${c.base04};
        @define-color border              ${c.base04};
        @define-color text-dark           ${c.base01};
        @define-color text-light          ${c.base05};
        @define-color black               ${c.base11};
        @define-color green               ${c.base0B};
        @define-color blue                ${c.base0D};
        @define-color red                 ${c.base08};
        @define-color purple              ${c.base0E};
        @define-color orange              ${c.base0F};
        @define-color bg-hover            alpha(@black, 0.2);
        @define-color bg-focus            alpha(@black, 0.1);
        @define-color bg-close            alpha(@black, 0.2);
        @define-color bg-close-hover      alpha(@black, 0.15);
        * {
          font-family: '${f.name}, ${i.name}';
        }
      '';
  };
}

{
  pkgs,
  config,
  lib,
  ...
}:
let
  g = config._base;
  cfg = config.modules.desktop.sway;
  moduleSwaync = "${g.flakeDirectory}/desktop/niri/swaync";
  c = config.modules.themes.colors.withHashtag;
  f = config.modules.fonts.app;
  i = config.modules.fonts.icon;
  extraPackages =
    g.system.envPackages
    ++ (with pkgs; [
      wlsunset
      foot
      grim
      slurp
      swappy
      cfg.finalPackage
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

  xdg.configFile =
    let
      symlink = file: config.lib.file.mkOutOfStoreSymlink file;
    in
    {
      "swaync/config.json".source = lib.mkForce (symlink "${moduleSwaync}/config.json");
      "swaync/styles".source = symlink "${moduleSwaync}/styles";
      # "swaync/style.css".source = symlink "${moduleSwaync}/style.css";
      "swaync/style.css".text =
        # css
        ''
          @define-color background ${c.base00};
          @define-color background-alt ${c.base01};
          @define-color text-dark ${c.base11};
          @define-color text-light ${c.base05};
          @define-color black ${c.base11};
          @define-color green ${c.green};
          @define-color orange ${c.orange};
          @define-color cyan ${c.cyan};
          @define-color blue ${c.blue};
          @define-color yellow ${c.yellow};
          @define-color red ${c.red};
          @define-color magenta ${c.magenta};
          @define-color brown ${c.brown};
          @import url("./styles/main.css");
        '';
    };
}

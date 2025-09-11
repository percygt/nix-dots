{
  pkgs,
  lib,
  config,
  ...
}:
let
  g = config._base;
  extraPackages =
    g.system.envPackages
    ++ (with pkgs; [
      swaynotificationcenter
      foot
      pomo
      iwmenu
      walker
      networkmanagerapplet
    ]);
  waybarWithExtraPackages =
    pkgs.runCommand "waybar"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
        meta.mainProgram = "waybar";
      }
      ''
        makeWrapper ${pkgs.waybar}/bin/waybar $out/bin/waybar --prefix PATH : ${lib.makeBinPath extraPackages}
      '';
  inherit (config._base) flakeDirectory;
  moduleWaybar = "${flakeDirectory}/desktop/niri/waybar";
  c = config.modules.themes.colors.withHashtag;
in
{
  services.playerctld.enable = true;
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    package = waybarWithExtraPackages;
  };
  xdg.configFile =
    let
      symlink = file: config.lib.file.mkOutOfStoreSymlink file;
    in
    {
      "waybar/config.jsonc".source = symlink "${moduleWaybar}/config.jsonc";
      "waybar/modules".source = symlink "${moduleWaybar}/modules";
      "waybar/styles".source = symlink "${moduleWaybar}/styles";
      "waybar/style.css".text =
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
          @import url("./extra.css");
        '';
    };
}

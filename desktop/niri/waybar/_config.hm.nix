{
  pkgs,
  lib,
  config,
  ...
}:
let
  g = config._base;
  autoCpufreqGovernor = pkgs.writeShellApplication {
    name = "auto-cpufreq-governor-exec";
    text = ''
      governor=$(cpufreqctl.auto-cpufreq -g | tr ' ' '\n' | head -n 1)
      output="󱠇"
      case $governor in
          "performance")
              output="󱠇"
              ;;
          "balance_power")
              output="󱎖"
              ;;
          "powersave")
              output="󱤅"
              ;;
          *)
              :
              ;;
      esac
      echo "''${output}"
    '';
  };
  extraPackages = [
    autoCpufreqGovernor
  ]
  ++ g.system.envPackages
  ++ (with pkgs; [
    swaynotificationcenter
    wlsunset
    foot
    pomo
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
  f = config.modules.fonts.interface;
  i = config.modules.fonts.icon;
  p = config.modules.fonts.propo;
in
{
  services.playerctld.enable = true;
  programs.waybar = {
    enable = true;
    package = waybarWithExtraPackages;
    systemd.enable = true;
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
          @define-color green ${c.base0B};
          @define-color peach ${c.base09};
          @define-color teal ${c.base0C};
          @define-color blue ${c.base0D};
          @define-color yellow ${c.base0A};
          @define-color red ${c.base08};
          @define-color purple ${c.base0E};
          @define-color orange ${c.base0F};
          @import url("./styles/main.css");
          @import url("./extra.css");
        '';
    };
}

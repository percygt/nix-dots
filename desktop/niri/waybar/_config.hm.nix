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

      output=""
      case $governor in
          "performance")
              output=""
              ;;
          "balance_power")
              output=""
              ;;
          "powersave")
              output=""
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
      # "waybar/common.jsonc".source = symlink "${moduleWaybar}/common.jsonc";
      "waybar/modules".source = symlink "${moduleWaybar}/modules";
      "waybar/styles".source = symlink "${moduleWaybar}/styles";
      "waybar/style.css".text =
        # css
        ''
          @define-color bg ${c.base00};
          @define-color bg-alt ${c.base01};
          @define-color grey ${c.base03};
          @define-color grey-alt ${c.base04};
          @define-color border ${c.base03};
          @define-color text-dark ${c.base11};
          @define-color text-light ${c.base05};
          @define-color black ${c.base11};
          @define-color green ${c.base0B};
          @define-color blue ${c.base0D};
          @define-color red ${c.base08};
          @define-color purple ${c.base0E};
          @define-color orange ${c.base0F};
          @define-color bg-hover rgba(255, 255, 255, 0.1);
          @define-color bg-focus rgba(255, 255, 255, 0.1);
          @define-color bg-close rgba(255, 255, 255, 0.1);
          @define-color bg-close-hover rgba(255, 255, 255, 0.15);
          @import url("./styles/main.css");
          @import url("./extra.css");
          * {
            font-family: '${f.name}, ${i.name}';
            font-size: ${toString f.size}px;
            font-weight: 600;
            min-height: 0px;
          }
        '';
    };
}

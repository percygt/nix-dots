{
  pkgs,
  lib,
  config,
  ...
}:
let
  g = config._global;
  nixosRebuild = pkgs.writeShellApplication {
    name = "waybar-rebuild-exec";
    runtimeInputs = g.system.envPackages;
    text = ''
      rebuild_status="$(systemctl is-active nixos-rebuild.service || true)"
      backup_status="$(systemctl is-active borgmatic.service || true)"
      if grep -q "failed" <<< "$backup_status"; then
        printf '{ "text" : "\udb84\udc4c ","class":"fail"}'
      elif grep -q "inactive" <<< "$rebuild_status"; then
        printf '{ "text" : "\uf313 ","class":"success"}'
      elif grep -q "active" <<< "$rebuild_status"; then
        printf '{ "text" : "\udb84\udc64 ","class":"ongoing"}'
      elif grep -q "failed" <<< "$rebuild_status"; then
        printf '{ "text" : "\udb84\udf62 ","class":"fail"}'
      fi
    '';
  };
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
    nixosRebuild
  ]
  ++ g.system.envPackages
  ++ (with pkgs; [
    toggle-service
    toggle-sway-window
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
  # inherit (config._global) flakeDirectory;
  # moduleWaybar = "${flakeDirectory}/desktop/sway/waybar";
  c = config.modules.themes.colors.withHashtag;
  f = config.modules.fonts.interface;
  i = config.modules.fonts.icon;
  cfg = config.wayland.windowManager.sway.config;
  mod = cfg.modifier;
  defaultSettings = import ./.settings.nix;
in
{
  services.playerctld.enable = true;
  programs.waybar = {
    enable = true;
    package = waybarWithExtraPackages;
    settings = {
      "bar-1" = defaultSettings // {
        id = "bar-1";
        ipc = true;
        output = "eDP-1";
      };
      "bar-2" = defaultSettings // {
        output = "!eDP-1";
      };
    };
    style = lib.readFile ./style.css;
  };
  xdg.configFile = {
    "waybar/nix.css".text =
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
        * {
          font-family: '${f.name}, ${i.name}';
          font-size: ${toString f.size}px;
          font-weight: 600;
          min-height: 0px;
        }
      '';
  };
}

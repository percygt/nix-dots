{
  config,
  pkgs,
  lib,
  libx,
  ...
}: let
  inherit (libx) toRasi fonts colors;
in {
  programs.waybar = {
    enable = true;

    style = toRasi (import ./theme.nix {inherit config fonts colors;}).theme;

    systemd.enable = true;
    systemd.target = "sway-session.target";

    settings = {
      main = {
        exclusive = true;
        position = "top";
        layer = "top";
        height = 16;
        passthrough = false;
        gtk-layer-shell = true;

        modules-left = ["idle_inhibitor" "sway/workspaces" "sway/window"];
        modules-center = ["sway/mode" "clock" "custom/wlsunset"];
        modules-right = [
          "tray"
          "backlight"
          "network"
          "cpu"
          "memory"
          "temperature"
          "wireplumber"
          # "bluetooth"
          "battery"
          "group/group-power"
        ];
        "sway/workspaces" = {
          format = "{icon}";
          all-outputs = true;
          format-icons = {
            "1" = "1| ";
            "2" = "2| ";
            "3" = "3|󰙀 ";
            "4" = "4| ";
            "5" = "5| ";
            "6" = "6| ";
            "7" = "7| ";
          };
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
            "6" = [];
            "7" = [];
          };
          on-click = "activate";
        };
        "custom/wlsunset" = {
          exec = "if systemctl --user --quiet is-active wlsunset.service; then echo ' '; else echo ' '; fi";
          interval = 2;
        };

        "sway/window" = {
          "format" = "{}";
        };

        cpu = {
          interval = 10;
          format = "{usage} ";
          on-click = "foot --app-id=system_monitor btop";
        };
        memory = {
          interval = 30;
          format = "{} ";
        };
        wireplumber = {
          format = "{node_name} {volume} {icon}";
          format-muted = "{volume} ";
          format-icons = {default = ["" ""];};
          on-click = "pavucontrol";
          on-click-right = "cycle-pulse-sink";
          on-click-middle = "helvum";
          max-volume = 100;
          scroll-step = 5;
        };
        network = {
          format-alt = "{ifname}";
          format-disconnected = "Disconnected ⚠";
          format-ethernet = "{ifname} 󰛳";
          format-linked = "{ifname} (No IP) 󰛳";
          format-wifi = "{essid} ({signalStrength}%) ";
          interval = 15;
          tooltip-format = "{ifname} / {essid} ({signalStrength}%) / {ipaddr}";
          max-length = 15;
          on-click = "foot ${pkgs.networkmanagerapplet}/bin/nm-applet";
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        "battery" = {
          states = {
            good = 95;
            warning = 20;
            critical = 10;
          };
          format = "{capacity}% {icon}";
          format-alt = "{time} {icon}";
          format-charging = "{capacity} ";
          format-full = "{capacity}% {icon}";
          format-good = "{capacity}% {icon}";
          format-icons = ["" "" "" "" ""];
          format-plugged = "{capacity}% ";
          max-length = 40;
        };

        "group/group-power" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
            transition-left-to-right = false;
          };
          modules = [
            "custom/power"
            # "custom/quit"
            "custom/lock"
            "custom/reboot"
          ];
        };

        # "custom/quit" = {
        #   format = "󰗼";
        #   on-click = "${pkgs.}/bin/hyprctl dispatch exit";
        #   tooltip = false;
        # };
        #
        "custom/lock" = {
          format = "󰍁";
          on-click = "${lib.getExe config.programs.swaylock.package}";
          tooltip = false;
        };
        #
        "custom/reboot" = {
          format = "󰜉";
          on-click = "${pkgs.systemd}/bin/systemctl reboot";
          tooltip = false;
        };

        "custom/power" = {
          format = "";
          on-click = "${pkgs.systemd}/bin/systemctl poweroff";
          tooltip = false;
        };

        "clock" = {format = "{:%m.%d %I:%M}";};
        # pattern = "MM.dd.yy' 🌣 'hh:mm:ss";
        backlight = {
          interval = 5;
          format = "{percent} {icon}";
          format-icons = ["" "" ""];
        };
        "sway/mode".format = "<span style=\"italic\">{}</span>";

        "temperature" = {
          critical-threshold = 80;
          format = "{temperatureC}°C ";
        };
      };
    };

    # This is a bit of a hack. Rasi turns out to be basically CSS, and there is
    # a handy helper to convert nix -> rasi in the home-manager module for rofi,
    # so I'm using that here to render the stylesheet for waybar
  };

  # # This is a hack to ensure that hyprctl ends up in the PATH for the waybar service on hyprland
  # systemd.user.services.waybar.Service.Environment =
  #   lib.mkForce
  #   "PATH=${lib.makeBinPath [pkgs."${desktop}"]}";
}

{
  config,
  pkgs,
  lib,
  desktop,
  libx,
  ...
}: let
  bluetoothToggle = pkgs.writeShellApplication {
    name = "bluetooth-toggle";
    runtimeInputs = with pkgs; [gnugrep bluez];
    text = ''
      if [[ "$(bluetoothctl show | grep -Po "Powered: \K(.+)$")" =~ no ]]; then
        bluetoothctl power on
        bluetoothctl discoverable on
      else
        bluetoothctl power off
      fi
    '';
  };
  inherit (import ./lib.nix {inherit lib;}) toRasi;
  inherit (libx) fonts colors;
in {
  programs.waybar = {
    enable = true;

    style = toRasi (import ./theme.nix {inherit config fonts colors;}).theme;

    systemd.enable = true;
    systemd.target = "sway-session.target";

    settings = {
      main = {
        # ipc = true;
        # id = "bar-0";
        exclusive = true;
        position = "top";
        layer = "top";
        height = 18;
        passthrough = false;
        gtk-layer-shell = true;

        modules-left = ["sway/workspaces"];
        modules-center = ["sway/mode" "clock" "idle_inhibitor"];
        modules-right = [
          "tray"
          "network"
          "backlight"
          "cpu"
          "memory"
          "temperature"
          "pulseaudio#source"
          # "wireplumber"
          "bluetooth"
          "battery#bat2"
          "group/group-power"
        ];

        "sway/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "󰙀";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
          };
          on-click = "activate";
        };

        "network" = {
          format-alt = "{ifname}";
          format-disconnected = "Disconnected ⚠";
          format-ethernet = "{ifname} 󰛳";
          format-linked = "{ifname} (No IP) 󰛳";
          format-wifi = "{essid} ({signalStrength}%) ";
          interval = 15;
          tooltip-format = "{ifname} / {essid} ({signalStrength}%) / {ipaddr}";
          max-length = 15;
          on-click = "${pkgs.foot}/bin/foot -e ${pkgs.networkmanager}/bin/nmtui";
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
          format-charging = "{capacity}% ";
          format-full = "{capacity}% {icon}";
          format-good = "{capacity}% {icon}";
          format-icons = ["" "" "" "" ""];
          format-plugged = "{capacity}% ";
        };

        "battery#bat2".bat = "BAT2";

        backlight.format = "{percent}% {icon}";
        backlight.format-icons = ["" ""];

        "group/group-power" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
            transition-left-to-right = false;
          };
          modules = [
            "custom/power"
            # "custom/quit"
            # "custom/lock"
            "custom/reboot"
          ];
        };

        # "custom/quit" = {
        #   format = "󰗼";
        #   on-click = "${pkgs.}/bin/hyprctl dispatch exit";
        #   tooltip = false;
        # };
        #
        # "custom/lock" = {
        #   format = "󰍁";
        #   on-click = "${lib.getExe pkgs.hyprlock}";
        #   tooltip = false;
        # };
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

        "clock" = {format = "{:%d %b %H:%M}";};

        "sway/mode".format = "<span style=\"italic\">{}</span>";

        "wireplumber" = {
          format = "{volume}% {icon}";
          format-muted = "";
          on-click = "${lib.getExe pkgs.pavucontrol}";
          format-icons = ["" "" ""];
          tooltip-format = "{volume}% / {node_name}";
        };

        "pulseaudio#source" = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "${lib.getExe pkgs.pavucontrol}";
          tooltip-format = "{source_volume}% / {desc}";
        };

        "temperature" = {
          critical-threshold = 80;
          format = "{temperatureC}°C ";
        };

        cpu.format = "{usage}% 󰍛";
        cpu.tooltip = true;

        memory.format = "{}% ";
        memory.tooltip = true;

        "bluetooth" = {
          format-on = "";
          format-connected = "{device_alias} ";
          format-off = "";
          format-disabled = "";
          on-click-right = "${lib.getExe' pkgs.blueberry "blueberry"}";
          on-click = "${lib.getExe bluetoothToggle}";
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

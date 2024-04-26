{
  config,
  pkgs,
  lib,
  libx,
  desktop,
  ...
}: let
  inherit (libx) toRasi fonts colors;
  toggle-sway-window = pkgs.writeBabashkaScript {
    name = "toggle-sway-window";
    text = builtins.readFile ../toggle-sway-window.clj;
  };
in {
  services.playerctld.enable = true;
  programs.waybar = {
    enable = true;

    style = toRasi (import ./theme.nix {inherit config fonts colors;}).theme;

    systemd.enable = true;
    systemd.target = "sway-session.target";

    settings = [
      {
        exclusive = true;
        position = "top";
        layer = "top";
        output = ["HDMI-A-1"];
        height = 16;
        margin-top = 0;
        margin-bottom = 0;
        passthrough = false;
        gtk-layer-shell = true;

        modules-left = ["sway/workspaces" "sway/window"];
        modules-center = ["sway/mode" "idle_inhibitor" "clock" "custom/wlsunset"];
        modules-right = ["mpris" "tray" "backlight" "network" "cpu" "memory" "temperature" "wireplumber" "pulseaudio#source" "battery" "group/group-power"];

        "sway/workspaces" = {
          format = "{icon}";
          disable-scroll = true;
          all-outputs = true;
          format-icons = {
            "1" = "1 | www";
            "2" = "2 | term";
            "3" = "3 | notes";
            "4" = "4 | media";
          };
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
          };
          on-click = "activate";
        };
        "tray" = {
          icon-size = 10;
          spacing = 10;
        };
        "sway/window" = {
          format = "❯ {}";
        };
        "mpris" = {
          format = "{player_icon} {dynamic}";
          format-paused = "{status_icon} {dynamic}";
          player-icons.default = "";
          status-icons.paused = "";
          dynamic-len = 45;
          dynamic-order = ["title" "artist" "album"];
          max-length = 80;
        };

        "cpu" = {
          interval = 10;
          format = " {usage}%";
          on-click = "${lib.getExe toggle-sway-window} --id btop -- foot --app-id=btop btop";
        };

        "memory" = {
          interval = 30;
          format = " {}%";
          on-click = "${lib.getExe toggle-sway-window} --id btop -- foot --app-id=btop btop";
        };

        "pulseaudio#source" = {
          format = "{format_source}";
          format-source = " ";
          format-source-muted = "  ";
          tooltip-format = "{source_volume}% / {desc}";
          on-click = "pamixer --default-source -t";
        };

        "wireplumber" = {
          format = "{node_name} {volume} {icon}";
          format-muted = "{volume} ";
          format-icons = {default = ["" "" ""];};
          on-click = "pamixer --toggle-mute";
          on-click-right = "${lib.getExe toggle-sway-window} --id pavucontrol -- pavucontrol";
          on-click-middle = "${lib.getExe toggle-sway-window} --id qpwgraph -- qpwgraph";
          tooltip-format = "{source_volume}% / {desc}";
          max-volume = 100;
          scroll-step = 5;
        };
        "network" = {
          format-disconnected = "Disconnected ⚠";
          format-ethernet = "󰛳 {ifname}";
          format-linked = "󰛳 {ifname} (No IP) ";
          format-wifi = " {essid} ({signalStrength}%)";
          interval = 15;
          tooltip-format = "{ifname} / {essid} ({signalStrength}%) / {ipaddr}";
          max-length = 15;
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = " ";
            deactivated = "a";
          };
        };

        "battery" = {
          states = {
            good = 95;
            warning = 20;
            critical = 10;
          };
          format = "{icon} {capacity}%";
          format-alt = "{icon} {time}";
          format-charging = " {capacity}";
          format-full = "{icon} {capacity}%";
          format-good = "{icon} {capacity}%";
          format-icons = ["" "" "" "" ""];
          format-plugged = " {capacity}%";
        };

        "clock" = {
          format = "{:%y.%m.%d | %I:%M:%S}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          interval = 1;
        };

        "custom/wlsunset" = {
          exec = "if systemctl --user --quiet is-active wlsunset.service; then echo ' '; else echo ' '; fi";
          on-click = "${lib.getExe pkgs.toggle-service} wlsunset";
          interval = 2;
        };

        "backlight" = {
          format = "{icon} {percent}%";
          format-icons = ["󰃚" "󰃞" "󰃠"];
          tooltip = false;
          on-scroll-down = "brightnessctl set 5%-";
          on-scroll-up = "brightnessctl set +5%";
        };

        "sway/mode".format = "<span style=\"italic\">{}</span>";

        "temperature" = {
          critical-threshold = 80;
          format = " {temperatureC}°C";
          thermal-zone = 7;
        };

        "group/group-power" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
            transition-left-to-right = false;
          };
          modules = [
            "custom/power"
            "custom/suspend"
            "custom/logout"
            "custom/lock"
            "custom/reboot"
          ];
        };

        "custom/logout" = {
          format = "";
          on-click = "swaymsg exit";
          tooltip = false;
        };
        "custom/suspend" = {
          format = "󰒲";
          on-click = "systemctl suspend";
          tooltip = false;
        };
        "custom/lock" = {
          format = "";
          on-click = "swaymsg exec swaylock";
          tooltip = false;
        };
        #
        "custom/reboot" = {
          format = "";
          on-click = "systemctl reboot";
          tooltip = false;
        };

        "custom/power" = {
          format = "⏻";
          on-click = "systemctl poweroff";
          tooltip = false;
        };
      }
    ];
  };
  systemd.user.services.waybar.Service.Environment =
    lib.mkForce
    "PATH=${lib.makeBinPath [pkgs."${desktop}" pkgs.foot pkgs.btop pkgs.qpwgraph pkgs.brightnessctl pkgs.pamixer pkgs.systemd]}";
}

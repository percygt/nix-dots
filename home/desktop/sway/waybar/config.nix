{
  mkWaybarFont,
  lib,
  colors,
  daylight,
}: let
  lavenderFnt = el:
    mkWaybarFont {
      i = el;
      c = colors.extra.lavender;
    };
  redFnt = el:
    mkWaybarFont {
      i = el;
      c = colors.normal.red;
    };
in {
  exclusive = true;
  layer = "top";
  height = 26;
  margin-top = 0;
  margin-bottom = 0;
  passthrough = false;
  gtk-layer-shell = true;
  # fixed-center = true;

  modules-left = ["sway/workspaces" "sway/window"];
  modules-center = ["clock#time" "custom/daylight" "clock#date"];
  modules-right = ["mpris" "tray" "cpu" "memory" "temperature" "wireplumber" "pulseaudio#source" "custom/wlsunset" "idle_inhibitor" "backlight" "network" "battery" "group/group-power"];

  "sway/workspaces" = {
    format = "{name}";
    # all-outputs = true;
    persistent-workspaces = {
      "1" = [];
      "2" = [];
      "3" = [];
      "4" = [];
    };
    on-click = "activate";
  };
  "tray" = {
    icon-size = 12;
    spacing = 5;
  };
  "sway/window" = {
    format = "{}";
  };

  "mpris" = {
    format = "{player_icon} {dynamic}";
    format-paused = "{status_icon} {dynamic}";
    player-icons.default = lavenderFnt " ";
    status-icons.paused = lavenderFnt " ";
    dynamic-len = 45;
    dynamic-order = ["artist" "title" "album"];
    max-length = 100;
  };

  "cpu" = {
    interval = 1;
    format = "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}";
    format-icons = [
      (lavenderFnt "▁")
      (lavenderFnt "▂")
      (lavenderFnt "▃")
      (lavenderFnt "▄")
      (lavenderFnt "▅")
      (lavenderFnt "▆")
      (lavenderFnt "▇")
      (redFnt "█")
    ];
  };

  "memory" = {
    interval = 30;
    format = "${lavenderFnt ""} {percentage}%    ${lavenderFnt ""}    {swapPercentage}%";
    tooltip = true;
    tooltip-format = "{used:0.1f}G/{total:0.1f}G | {swapUsed:0.1f}G/{swapTotal:0.1f}G";
    on-click = "toggle-sway-window --id btop -- foot --app-id=btop btop";
  };

  "temperature" = {
    thermal-zone = 7;
    critical-threshold = 80;
    tooltip = false;
    format = "${lavenderFnt "{icon}"} {temperatureC}°C";
    format-icons = ["" "" "" "" ""];
    on-click = "toggle-sway-window --id btop -- foot --app-id=btop btop";
  };

  "pulseaudio#source" = {
    format-source = "";
    format = lavenderFnt "{format_source}";
    format-source-muted = "";
    tooltip-format = "{source_volume}% / {desc}";
    on-click = "pamixer --default-source -t";
  };

  "wireplumber" = {
    format = "${lavenderFnt "{icon}"}  {volume}% {node_name}";
    format-muted = "${lavenderFnt ""}    {volume}";
    format-icons = {default = ["" "" ""];};
    on-click = "pamixer --toggle-mute";
    on-click-right = "toggle-sway-window --id pavucontrol -- pavucontrol";
    tooltip-format = "{source_volume}% / {desc}";
    max-volume = 100;
    scroll-step = 5;
  };

  "network" = {
    format-disconnected = lavenderFnt "󰲛";
    format-ethernet = lavenderFnt "󰛳";
    format-linked = "${lavenderFnt "󰛳"} (No IP)";
    format-wifi = "${lavenderFnt ""}";
    tooltip-format = "{ifname} / {essid} ({signalStrength}%) / {ipaddr}";
    on-click = "toggle-sway-window --id wpa_gui -- wpa_gui";
    max-length = 15;
  };

  "idle_inhibitor" = {
    format = "{icon}";
    format-icons = {
      activated = lavenderFnt "󱎴";
      deactivated = lavenderFnt "󰍹";
    };
  };

  "battery" = {
    states = {
      good = 95;
      warning = 20;
      critical = 10;
    };
    format = "${lavenderFnt "{icon}"} {capacity}%";
    format-alt = "${lavenderFnt "{icon}"} {time}";
    format-charging = "${lavenderFnt ""} {capacity}%";
    format-full = "${lavenderFnt "{icon}"} {capacity}%";
    format-good = "${lavenderFnt "{icon}"} {capacity}%";
    format-icons = ["" "" "" "" ""];
    format-plugged = lavenderFnt "";
  };

  "clock#date" = {
    format = "{:%m.%d.%y}";
    tooltip-format = "<tt><small>{calendar}</small></tt>";
    interval = 3600;
    min-length = 7;
  };
  "custom/daylight" = {
    format = "{}";
    exec = "${lib.getExe daylight}";
    interval = 3600;
    tooltip = false;
  };
  "clock#time" = {
    format = "{:%I:%M:%S}";
    tooltip-format = "<tt><small>{calendar}</small></tt>";
    interval = 1;
    min-length = 7;
  };

  "custom/wlsunset" = {
    format = lavenderFnt "{}";
    exec = "if systemctl --user --quiet is-active wlsunset.service; then echo ''; else echo ''; fi";
    on-click = "toggle-service wlsunset";
    interval = 2;
    tooltip = false;
  };

  "backlight" = {
    format = "${lavenderFnt "{icon}"}";
    format-icons = ["󱩎" "󱩏" "󱩐" "󱩑" "󱩓" "󱩔" "󱩕" "󱩖" "󰛨"];
    tooltip = false;
    on-scroll-down = "brightnessctl set 5%-";
    on-scroll-up = "brightnessctl set +5%";
  };

  "sway/mode".format = "<span style=\"italic\">{}</span>";

  "group/group-power" = {
    orientation = "inherit";
    drawer = {
      transition-duration = 500;
      transition-left-to-right = false;
      children-class = "group-power";
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
    format = lavenderFnt "";
    on-click = "swaymsg exit";
    tooltip = false;
  };

  "custom/suspend" = {
    format = lavenderFnt "󰒲";
    on-click = "systemctl suspend";
    tooltip = false;
  };

  "custom/lock" = {
    format = lavenderFnt "";
    on-click = "swaymsg exec swaylock";
    tooltip = false;
  };

  "custom/reboot" = {
    format = lavenderFnt "";
    on-click = "systemctl reboot";
    tooltip = false;
  };

  "custom/power" = {
    format = lavenderFnt "⏻";
    on-click = "systemctl poweroff";
    tooltip = false;
  };
}

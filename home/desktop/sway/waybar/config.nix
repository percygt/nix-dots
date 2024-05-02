{
  mkWaybarFont,
  colors,
}: let
  im = el: mkWaybarFont {i = el;};
  ib = el:
    mkWaybarFont {
      i = el;
      c = colors.normal.blue;
    };
  ir = el:
    mkWaybarFont {
      i = el;
      c = colors.normal.red;
    };
  il = el:
    mkWaybarFont {
      i = el;
      s = "large";
      c = colors.normal.yellow;
    };
in {
  exclusive = true;
  layer = "top";
  height = 16;
  margin-top = 0;
  margin-bottom = 0;
  passthrough = false;
  gtk-layer-shell = true;
  fixed-center = true;

  modules-left = ["sway/workspaces" "sway/window"];
  modules-center = ["sway/mode" "clock"];
  modules-right = ["mpris" "cpu" "memory" "temperature" "wireplumber" "pulseaudio" "tray" "custom/wlsunset" "idle_inhibitor" "backlight" "network" "battery" "group/group-power"];

  "sway/workspaces" = {
    format = "{icon}";
    # all-outputs = true;
    format-icons = {
      "1" = "1";
      "2" = "2";
      "3" = "3";
      "4" = "4";
      "5" = "5";
      "6" = "6";
      "7" = "7";
      "8" = "8";
      "9" = "9";
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
    icon-size = 12;
    spacing = 5;
  };
  "sway/window" = {
    format = "{}";
  };

  "mpris" = {
    format = "{player_icon} {dynamic}";
    format-paused = "{status_icon} {dynamic}";
    player-icons.default = im " ";
    status-icons.paused = im " ";
    dynamic-len = 45;
    dynamic-order = ["title" "artist" "album"];
    max-length = 100;
  };

  "cpu" = {
    interval = 1;
    format = "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}";
    format-icons = [
      (ib "▁")
      (ib "▂")
      (ib "▃")
      (ib "▄")
      (ib "▅")
      (ib "▆")
      (ib "▇")
      (ir "█")
    ];
  };

  "memory" = {
    interval = 30;
    format = " {percentage}%       {swapPercentage}%";
    tooltip = true;
    tooltip-format = "{used:0.1f}G/{total:0.1f}G | {swapUsed:0.1f}G/{swapTotal:0.1f}G";
    on-click = "toggle-sway-window --id btop -- foot --app-id=btop btop";
  };

  "temperature" = {
    thermal-zone = 7;
    critical-threshold = 80;
    tooltip = false;
    format = "{icon}{temperatureC}°C";
    format-icons = ["" "" "" "" ""];
    on-click = "toggle-sway-window --id btop -- foot --app-id=btop btop";
  };

  "pulseaudio" = {
    format-source = "";
    format = im "{format_source}";
    format-source-muted = "";
    tooltip-format = "{source_volume}% / {desc}";
    on-click = "pamixer --default-source -t";
  };

  "wireplumber" = {
    format = "{icon} {volume}% {node_name}";
    format-muted = "   {volume}";
    format-icons = {default = ["" "" ""];};
    on-click = "pamixer --toggle-mute";
    on-click-right = "toggle-sway-window --id pavucontrol -- pavucontrol";
    tooltip-format = "{source_volume}% / {desc}";
    max-volume = 100;
    scroll-step = 5;
  };

  "network" = {
    format-disconnected = im "󰲛";
    format-ethernet = im "󰛳";
    format-linked = "${im "󰛳"} (No IP)";
    format-wifi = "${im ""}{signalStrength}%";
    tooltip-format = "{ifname} / {essid} ({signalStrength}%) / {ipaddr}";
    max-length = 15;
  };

  "idle_inhibitor" = {
    format = "{icon}";
    format-icons = {
      activated = im "󱎴";
      deactivated = im "󰍹";
    };
  };

  "battery" = {
    states = {
      good = 95;
      warning = 20;
      critical = 10;
    };
    format = "${im "{icon}"} {capacity}%";
    format-alt = "${im "{icon}"} {time}";
    format-charging = "${im ""} {capacity}%";
    format-full = "${im "{icon}"} {capacity}%";
    format-good = "${im "{icon}"} {capacity}%";
    format-icons = ["" "" "" "" ""];
    format-plugged = im "";
  };

  "clock" = {
    format = "{:%y.%m - %I:%M}";
    format-alt = "{:%a, %d. %b  %H:%M}";
    tooltip-format = "<tt><small>{calendar}</small></tt>";
    interval = 1;
  };

  "custom/wlsunset" = {
    format = im "{}";
    exec = "if systemctl --user --quiet is-active wlsunset.service; then echo ''; else echo ''; fi";
    on-click = "toggle-service wlsunset";
    interval = 2;
    tooltip = false;
  };

  "backlight" = {
    format = "{icon}";
    format-icons = [
      (im "󱩎")
      (im "󱩏")
      (im "󱩐")
      (im "󱩑")
      (im "󱩑")
      (im "󱩓")
      (im "󱩔")
      (im "󱩕")
      (im "󱩖")
      (il "󰛨")
    ];
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
    format = ib "";
    on-click = "swaymsg exit";
    tooltip = false;
  };

  "custom/suspend" = {
    format = ib "󰒲";
    on-click = "systemctl suspend";
    tooltip = false;
  };

  "custom/lock" = {
    format = ib "";
    on-click = "swaymsg exec swaylock";
    tooltip = false;
  };

  "custom/reboot" = {
    format = ib "";
    on-click = "systemctl reboot";
    tooltip = false;
  };

  "custom/power" = {
    format = im "⏻";
    on-click = "systemctl poweroff";
    tooltip = false;
  };
}

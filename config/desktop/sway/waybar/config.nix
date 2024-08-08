{
  position = "top";
  exclusive = true;
  layer = "top";
  margin-top = 0;
  margin-left = 0;
  margin-right = 0;
  height = 25;
  spacing = 5;
  passthrough = false;
  gtk-layer-shell = true;
  fixed-center = true;

  modules-left = [
    "sway/workspaces"
    "sway/window"
  ];
  modules-center = [
    "clock#time"
    "clock#icon"
    "clock#date"
  ];
  modules-right = [
    "mpris"
    "tray"
    "cpu"
    "memory"
    "temperature"
    "wireplumber"
    "custom/rebuild"
    "pulseaudio#source"
    "idle_inhibitor"
    "custom/wlsunset"
    "backlight"
    "network"
    "battery"
    "group/group-power"
  ];

  "sway/workspaces" = {
    format = "{icon}";
    disable-scroll = true;
    persistent-workspaces = {
      "0-home" = [ "eDP-1" ];
      "1" = [ ];
      "2" = [ ];
      "3" = [ ];
      "4" = [ ];
      "5" = [ ];
    };
    format-icons = {
      "0-home" = "󰋜";
    };
    on-click = "activate";
  };
  "tray" = {
    icon-size = 12;
    spacing = 5;
  };

  "sway/window" = {
    format = "<span font='9' rise='-4444'>{}</span>";
    all-outputs = true;
    icon = true;
    icon-size = 12;
  };

  "mpris" = {
    format = "<span font='9' rise='-4444'>{player_icon} {dynamic}</span>";
    format-paused = "<span font='10' rise='-4444'>{status_icon} {dynamic}</span>";
    player-icons.default = " ";
    status-icons.paused = " ";
    dynamic-len = 45;
    dynamic-order = [
      "artist"
      "title"
      "album"
    ];
    max-length = 100;
  };

  "cpu" = {
    interval = 1;
    format = "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}";
    format-icons = [
      "▁"
      "▂"
      "▃"
      "▄"
      "▅"
      "▆"
      "▇"
      "<span color='red'>█</span>"
    ];
  };

  "memory" = {
    interval = 30;
    format = "󰆼 {percentage}%     󰿡  {swapPercentage}%";
    tooltip = true;
    tooltip-format = "{used:0.1f}G/{total:0.1f}G | {swapUsed:0.1f}G/{swapTotal:0.1f}G";
    on-click = "toggle-sway-window --id btop -- foot --app-id=btop btop";
  };

  "temperature" = {
    thermal-zone = 7;
    critical-threshold = 80;
    tooltip = false;
    format = "<small>{icon}</small> {temperatureC}°C";
    format-icons = [
      ""
      ""
      ""
      ""
      ""
    ];
    on-click = "toggle-sway-window --id btop -- foot --app-id=btop btop";
  };

  "pulseaudio#source" = {
    format-source = "";
    format = "{format_source}";
    format-source-muted = "";
    tooltip-format = "{source_volume}% / {desc}";
    on-click = "pamixer --default-source -t";
    min-length = 2;
  };

  "wireplumber" = {
    format = "{icon}  {volume}% {node_name}";
    format-muted = " ";
    format-icons = {
      default = [
        ""
        ""
        ""
      ];
    };
    on-click = "pamixer --toggle-mute";
    on-click-right = "toggle-sway-window --id pavucontrol -- pavucontrol";
    tooltip-format = "{source_volume}% / {desc}";
    max-volume = 100;
    scroll-step = 5;
  };

  "network" = {
    format-disconnected = "󰲛";
    format-ethernet = "󰈀";
    format-linked = "󰈀 (No IP)";
    format-wifi = "";
    tooltip-format = "{ifname} / {essid} ({signalStrength}%) / {ipaddr}";
    on-click = "toggle-sway-window --id wpa_gui -- wpa_gui";
    max-length = 15;
  };

  "idle_inhibitor" = {
    format = "{icon}";
    format-icons = {
      activated = "󰌿";
      deactivated = "󱙱";
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
    format-charging = " {capacity}%";
    format-full = "{icon} {capacity}%";
    format-good = "{icon} {capacity}%";
    format-icons = [
      ""
      ""
      ""
      ""
      ""
    ];
    format-plugged = "<span size='medium'></span>";
  };

  "clock" = {
    format = "{:%I:%M  :%Y-%m-%d}";
    tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    interval = 60;
    min-length = 7;
  };

  "custom/wlsunset" = {
    format = "{}";
    exec = "if systemctl --user --quiet is-active wlsunset.service; then echo '󰖔'; else echo '󰃚'; fi";
    on-click = "toggle-service wlsunset; pkill -SIGRTMIN+8 waybar";
    tooltip = false;
    signal = 8;
  };

  "backlight" = {
    format = "{icon}";
    format-icons = [
      "󰃞"
      "󰃟"
      "󰃠"
    ];
    tooltip = false;
    on-scroll-down = "brightnessctl set 5%-";
    on-scroll-up = "brightnessctl set +5%";
  };

  "sway/mode".format = ''<span style="italic">{}</span>'';

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
    format = "";
    on-click = "swaymsg exit";
    tooltip = false;
  };

  "custom/suspend" = {
    format = "󰪓";
    on-click = "systemctl suspend";
    tooltip = false;
  };

  "custom/lock" = {
    format = "<small>󰷛</small>";
    on-click = "swaymsg exec swaylock";
    tooltip = false;
  };

  "custom/reboot" = {
    format = "󰜉";
    on-click = "systemctl reboot";
    tooltip = false;
  };

  "custom/power" = {
    format = "⏻";
    on-click = "systemctl poweroff";
    tooltip = false;
  };
  "custom/rebuild" = {
    format = "{}";
    max-length = 12;
    interval = 2;
    signal = 12;
    return-type = "json";
    exec = "waybar-rebuild-exec";
    on-click = "toggle-sway-window --id=system-software-update  -- foot --title=NixosRebuild --app-id=system-software-update -- journalctl -efo cat -u nixos-rebuild.service";
  };
}

{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "sway-session.target";
    style = pkgs.runCommand "waybar-styles.css" {} ''
      sed -e 's/font-family: /font-family: Rubik, /'              \
          -e 's/font-size: 12px/font-size: 12px/' \
          ${pkgs.waybar}/etc/xdg/waybar/style.css > $out
    '';
    settings = [
      {
        layer = "top";
        position = "top";
        height = 26;
        output = [
          "HDMI-A-1"
        ];

        modules-left = ["sway/workspaces"];
        modules-center = ["sway/mode" "clock" "idle_inhibitor"];
        modules-right = ["tray" "pulseaudio" "backlight" "cpu" "memory" "temperature" "battery" "battery#bat2"];

        "sway/workspaces" = {
          disable-scroll = true;
          format = "{icon}";
          format-icons = {
            "1" = ""; # Ⅰ
            "2" = ""; # Ⅱ
            "3" = ""; # Ⅲ
            "4" = "Ⅳ";
            "5" = "Ⅴ";
            "6" = "Ⅵ";
            "7" = "Ⅶ";
            "8" = "Ⅷ";
            "9" = "Ⅸ";
            "10" = "Ⅹ";
            default = "";
          };
        };

        "sway/mode".format = "<span style=\"italic\">{}</span>";

        "battery#bat2".bat = "BAT2";

        backlight.format = "{percent}% {icon}";
        backlight.format-icons = ["" ""];

        battery.format = "{capacity}% {icon}";
        battery.format-alt = "{time} {icon}";
        battery.format-charging = "{capacity}% ";
        battery.format-full = "{capacity}% {icon}";
        battery.format-good = "{capacity}% {icon}";
        battery.format-icons = ["" "" "" "" ""];
        battery.format-plugged = "{capacity}% ";
        battery.states = {
          good = 80;
          warning = 30;
          critical = 15;
        };

        clock.format = "<span color=\"#88c0d0\"></span> {:%Y-%m-%d %H:%M:%S}";
        clock.interval = 5;

        cpu.format = "{usage}% ";
        cpu.tooltip = true;

        idle_inhibitor.format = "{icon}";
        idle_inhibitor.format-icons.activated = "";
        idle_inhibitor.format-icons.deactivated = "";

        memory.format = "{}% ";

        network.format-alt = "{ifname}: {ipaddr}/{cidr}";
        network.format-disconnected = "Disconnected ⚠";
        network.format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
        network.format-linked = "{ifname} (No IP) ";
        network.format-wifi = "{essid} ({signalStrength}%) ";
        network.interval = 15;

        pulseaudio.format = "{volume}% {icon} {format_source}";
        pulseaudio.format-bluetooth = "{volume}% {icon} {format_source}";
        pulseaudio.format-bluetooth-muted = " {icon} {format_source}";
        pulseaudio.format-muted = " {format_source}";
        pulseaudio.format-source = "{volume}% ";
        pulseaudio.format-source-muted = "";
        pulseaudio.format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" ""];
        };
        pulseaudio.on-click = "${pkgs.pavucontrol}/bin/pavucontrol";

        temperature.critical-threshold = 80;
        temperature.format = "{icon} {temperatureC}°C";
        temperature.format-icons = ["" "" ""];
      }
    ];
  };
}

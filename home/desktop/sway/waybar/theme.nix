{
  colors,
  fonts,
  mkLiteral,
  ...
}: {
  theme = let
    bg = mkLiteral "#${colors.default.background}";
    bg2 = mkLiteral "#${colors.extra.azure}";
    rubik = fonts.interface.name;
    font_awesome = fonts.icon.name;
    fsize = "${toString fonts.interface.size}px";
  in {
    "*" = {
      border = mkLiteral "none";
      font-family = "${rubik}, ${font_awesome}";
      font-size = mkLiteral fsize;
    };
    "window#waybar" = {
      background-color = bg;
      color = mkLiteral "#${colors.extra.lavender}";
    };
    "label.module" = {
      padding = mkLiteral "0px";
      margin = mkLiteral "0px";
    };
    "tooltip" = {
      padding = mkLiteral "15px 15px";
    };
    ".modules-right" = {
      padding-top = mkLiteral "1px";
      padding-right = mkLiteral "0px";
    };
    ".modules-center" = {
      padding-top = mkLiteral "1px";
      margin = mkLiteral "0px";
    };
    ".modules-left" = {
      padding-left = mkLiteral "0px";
    };
    "#custom-daylight,
    #clock" = {
      padding = mkLiteral "0px";
    };
    "#workspaces" = {
      padding = mkLiteral "0";
      margin = mkLiteral "0";
    };
    "#workspaces button" = {
      margin = mkLiteral "0";
      padding = mkLiteral "1px 0 0 0";
      color = mkLiteral "#${colors.extra.overlay1}";
      border-radius = mkLiteral "0px";
    };
    "#workspaces button:hover" = {
      color = mkLiteral "#${colors.extra.lavender}";
      background-color = bg2;
    };
    "#workspaces button.focused, #workspaces button.active" = {
      font-weight = mkLiteral "500";
      background-color = bg2;
    };

    "#group-power" = {
      padding = mkLiteral "0px";
    };
    "#custom-power, #custom-logout, #custom-suspend, #custom-lock, #custom-reboot" = {
      padding-right = mkLiteral "10px";
    };
    "#pulseaudio,
    #cpu,
    #tray,
    #custom-wlsunset,
    #battery,
    #bluetooth,
    #network,
    #temperature,
    #backlight,
    #idle_inhibitor,
    #memory,
    #window,
    #wireplumber" = {
      padding = mkLiteral "0px 5px";
    };
    "#mpris" = {
      padding = mkLiteral "0px 10px";
    };
    "#temperature.critical" = {
      color = mkLiteral "#${colors.normal.red}";
    };
    "#battery.charging" = {
      color = mkLiteral "#${colors.normal.green}";
    };
    "#battery.warning:not(.charging)" = {
      color = mkLiteral "#${colors.normal.yellow}";
    };
    "#battery.critical:not(.charging)" = {
      color = mkLiteral "#${colors.normal.red}";
    };
    "#wireplumber.muted" = {
      color = mkLiteral "#${colors.extra.overlay1}";
    };
    "#pulseaudio.source-muted" = {
      color = mkLiteral "#${colors.extra.overlay1}";
    };
  };
}

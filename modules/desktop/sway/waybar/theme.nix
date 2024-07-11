{
  colors,
  fonts,
  mkLiteral,
  ...
}: {
  theme = let
    bg = mkLiteral "#${colors.default.background}";
    rubik = fonts.interface.name;
    font_awesome = fonts.icon.name;
    fsize = "${toString fonts.interface.size}px";
  in {
    "*" = {
      border = mkLiteral "none";
      font-family = "${rubik}, ${font_awesome}";
      font-size = mkLiteral fsize;
      min-height = mkLiteral "0px";
    };
    "window#waybar" = {
      background-color = bg;
      color = mkLiteral "#${colors.extra.lavender}";
    };
    "label.module" = {
      padding = mkLiteral "0px";
      margin = mkLiteral "0px";
    };
    # "tooltip" = {
    #   padding = mkLiteral "15px 15px";
    # };
    ".modules-right" = {
      padding = mkLiteral "0px 7px 0px 0px";
    };
    ".modules-center" = {
      padding = mkLiteral "0px 7px 0px 0px";
    };
    ".modules-left" = {
      padding = mkLiteral "0px 7px 0px 0px";
    };

    "#custom-daylight,
    #clock" = {
      padding = mkLiteral "0px 5px";
      font-weight = mkLiteral "400";
    };
    "#workspaces" = {
      padding-left = mkLiteral "7px";
      margin = mkLiteral "0px";
    };
    "#workspaces button" = {
      margin = mkLiteral "0px";
      padding = mkLiteral "0px";
      color = mkLiteral "#${colors.extra.overlay1}";
      border-radius = mkLiteral "5px";
    };
    "#workspaces button:hover" = {
      color = mkLiteral "#${colors.extra.lavender}";
    };
    "#workspaces button.focused, #workspaces button.active" = {
      font-weight = mkLiteral "500";
      color = mkLiteral "#${colors.extra.lavender}";
    };

    "#group-power" = {
      padding = mkLiteral "0px";
    };

    "#custom-power" = {
      padding-right = mkLiteral "7px";
    };
    "#custom-reboot" = {
      padding = mkLiteral "0 15px 0 10px";
    };
    "#custom-logout, #custom-suspend, #custom-lock" = {
      padding = mkLiteral "0 10px";
    };

    "#cpu,
    #tray,
    #custom-wlsunset,
    #custom-rebuild,
    #bluetooth,
    #temperature,
    #memory,
    #window
    #pulseaudio,
    #wireplumber" = {
      padding = mkLiteral "0px 5px";
    };

    "#custom-wlsunset,
    #battery,
    #network,
    #backlight,
    #idle_inhibitor" = {
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

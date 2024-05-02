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
      background-color = bg;
    };

    "label.module" = {
      padding = mkLiteral "0 10px";
    };

    "tooltip" = {
      padding = mkLiteral "15px 15px";
    };

    ".modules-right" = {
      margin-left = mkLiteral "5px";
      padding = mkLiteral "0px";
    };

    ".modules-center" = {
      margin = mkLiteral "0px";
      padding = mkLiteral "0px";
    };

    ".modules-left" = {
      margin-right = mkLiteral "5px";
      padding = mkLiteral "0px";
    };

    "#clock" = {
      font-weight = mkLiteral "700";
      padding = mkLiteral "0px 5px";
    };
    "#workspaces button" = {
      margin = mkLiteral "0";
      color = mkLiteral "#${colors.extra.overlay1}";
      padding = mkLiteral "0";
    };

    "#workspaces button:hover" = {
      color = mkLiteral "#${colors.bold}";
      background-color = bg2;
    };

    "#workspaces button.focused, #workspaces button.active" = {
      color = mkLiteral "#${colors.bold}";
      font-weight = mkLiteral "700";
    };

    "#battery,
      #window,
      #bluetooth,
      #custom-lock,
      #custom-reboot,
      #custom-logout,
      #custom-suspend,
      #custom-wlsunset,
      #backlight,
      #network,
      #tray
      #wireplumber" = {
      padding = mkLiteral "0px 5px";
      color = mkLiteral "#${colors.default.foreground}";
    };

    "#pulseaudio" = {
      padding = mkLiteral "0px 5px";
      margin = mkLiteral "0px";
    };

    "#custom-power" = {
      color = mkLiteral "#${colors.normal.blue}";
      padding = mkLiteral "0px 5px";
      margin = mkLiteral "0px";
      background-color = bg;
    };

    "#cpu,
      #memory,
      #temperature" = {
      padding = mkLiteral "0 5px";
      color = mkLiteral "#${colors.normal.white}";
    };

    "#custom-logout, #custom-suspend, #custom-lock, #custom-reboot" = {
      color = mkLiteral "#${colors.normal.yellow}";
      background-color = bg2;
    };
    "#mpris" = {
      padding = mkLiteral "0px 10px";
      color = mkLiteral "#${colors.default.foreground}";
    };
    "#window" = {
      background-color = bg;
      color = mkLiteral "#${colors.bold}";
      padding = mkLiteral "0px";
    };

    "#idle_inhibitor" = {
      color = mkLiteral "#${colors.default.foreground}";
      padding = mkLiteral "0px 5px";
    };
    "#idle_inhibitor.activated" = {
      color = mkLiteral "#${colors.normal.blue}";
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

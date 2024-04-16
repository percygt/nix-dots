{
  config,
  colors,
  fonts,
  ...
}: {
  theme = let
    inherit (config.lib.formats.rasi) mkLiteral;
  in {
    "*" = {
      border = mkLiteral "none";
      padding = mkLiteral "0px";
      font-family = "VictorMono Nerd Font";
      font-size = mkLiteral "12px";
    };

    "window#waybar" = {
      background-color = mkLiteral "transparent";
    };

    "window>box" = {
      margin = mkLiteral "0px";
      background = mkLiteral "#${colors.default.background}";
      opacity = mkLiteral "0.8";
      border-radius = mkLiteral "0px";
    };

    ".modules-right" = {
      margin-right = mkLiteral "5px";
      padding = mkLiteral "0px";
    };

    ".modules-center" = {
      margin = mkLiteral "0px";
      padding = mkLiteral "5px 10px";
    };

    ".modules-left" = {
      margin-left = mkLiteral "0px";
      padding = mkLiteral "0px";
    };

    "#workspaces button" = {
      padding = mkLiteral "0px";
      background-color = mkLiteral "transparent";
      font-weight = mkLiteral "lighter";
      border-radius = mkLiteral "0px";
      color = mkLiteral "#${colors.default.foreground}";
    };

    "#workspaces button:hover" = {
      color = mkLiteral "#${colors.bold}";
      background-color = mkLiteral "transparent";
    };

    "#workspaces button.focused, #workspaces button.active" = {
      color = mkLiteral "#${colors.bold}";
      font-weight = mkLiteral "normal";
      background-color = mkLiteral "transparent";
    };

    "#battery,
      #bluetooth,
      #clock,
      #cpu,
      #custom-lock,
      #custom-power,
      #custom-quit,
      #custom-reboot,
      #group-group-power,
      #idle_inhibitor,
      #backlight,
      #memory,
      #network,
      #pulseaudio,
      #wireplumber" = {
      padding = mkLiteral "0px 10px";
      color = mkLiteral "#${colors.default.foreground}";
    };

    "#custom-power" = {
      color = mkLiteral "#${colors.bold}";
      background-color = mkLiteral "transparent";
    };

    "#custom-quit, #custom-lock, #custom-reboot" = {
      color = mkLiteral "#${colors.normal.red}";
      background-color = mkLiteral "transparent";
    };

    /*
    -----Indicators----
    */
    "#idle_inhibitor.activated" = {
      color = mkLiteral "#${colors.bold}";
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

    "#temperature.critical" = {
      color = mkLiteral "#${colors.normal.red}";
    };

    "#bluetooth.off" = {
      color = mkLiteral "#${colors.normal.yellow}";
    };

    "#wireplumber.muted" = {
      color = mkLiteral "#${colors.normal.yellow}";
    };

    "#pulseaudio.source-muted" = {
      color = mkLiteral "#${colors.normal.yellow}";
    };
  };
}

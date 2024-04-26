{
  config,
  colors,
  fonts,
  ...
}: {
  theme = let
    inherit (config.lib.formats.rasi) mkLiteral;
    bg = mkLiteral "#${colors.default.background}";
    bg2 = mkLiteral "#${colors.extra.azure}";
  in {
    "*" = {
      border = mkLiteral "none";
      font-family = "${fonts.interface.name}";
      font-size = mkLiteral "12px";
      font-weight = mkLiteral "700";
      background-color = bg;
      padding = mkLiteral "0px";
    };

    ".modules-right" = {
      margin-right = mkLiteral "0px";
      padding = mkLiteral "0px";
    };

    ".modules-center" = {
      margin = mkLiteral "0px";
      padding = mkLiteral "0px 10px";
    };

    ".modules-left" = {
      margin-left = mkLiteral "0px";
      padding = mkLiteral "0px";
    };

    "#workspaces button" = {
      margin = mkLiteral "0px 5px";
      color = mkLiteral "#${colors.extra.overlay1}";
      border-radius = mkLiteral "0px";
    };

    "#workspaces button:hover" = {
      color = mkLiteral "#${colors.bold}";
      background-color = bg2;
    };

    "#workspaces button.focused, #workspaces button.active" = {
      color = mkLiteral "#${colors.bold}";
      font-weight = mkLiteral "bold";
    };

    "#battery,
      #window,
      #bluetooth,
      #clock,
      #cpu,
      #custom-lock,
      #custom-power,
      #custom-reboot,
      #custom-logout,
      #custom-suspend,
      #custom-wlsunset,
      #group-group-power,
      #idle_inhibitor,
      #backlight,
      #memory,
      #temperature,
      #network,
      #tray
      #pulseaudio,
      #pulseaudio-source,
      #wireplumber" = {
      padding = mkLiteral "0px 10px";
      color = mkLiteral "#${colors.default.foreground}";
    };
    "#custom-power" = {
      color = mkLiteral "#${colors.bold}";
      margin = mkLiteral "0px 5px";
      background-color = bg;
    };

    "#custom-logout, #custom-suspend, #custom-lock, #custom-reboot" = {
      background-color = bg2;
    };
    "#mpris" = {
      padding = mkLiteral "0px 10px";
      color = mkLiteral "#${colors.default.foreground}";
    };
    "#window" = {
      background-color = bg;
      color = mkLiteral "#${colors.bold}";
      font-weight = mkLiteral "bold";
      padding = mkLiteral "0px";
    };
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
    "#wireplumber.muted" = {
      color = mkLiteral "#${colors.normal.yellow}";
    };
    "#pulseaudio.source-muted" = {
      color = mkLiteral "#${colors.normal.yellow}";
    };
  };
}

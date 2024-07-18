{
  fonts,
  mkLiteral,
  config,
  ...
}:
let
  c = config.scheme.withHashtag;
in
{
  theme =
    let
      bg = mkLiteral "${c.base00}";
      rubik = fonts.interface.name;
      font_awesome = fonts.icon.name;
      fsize = "${toString fonts.interface.size}px";
    in
    {
      "*" = {
        border = mkLiteral "none";
        font-family = "${rubik}, ${font_awesome}";
        font-size = mkLiteral fsize;
        min-height = mkLiteral "0px";
      };
      "window#waybar" = {
        background-color = bg;
        color = mkLiteral "${c.base05}";
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

      "#custom-daylight, #clock" = {
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
        color = mkLiteral "${c.base03}";
        border-radius = mkLiteral "5px";
      };
      "#workspaces button:hover" = {
        color = mkLiteral "${c.base05}";
      };
      "#workspaces button.focused, #workspaces button.active" = {
        font-weight = mkLiteral "500";
        color = mkLiteral "${c.base05}";
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

      "#cpu, #tray, #custom-wlsunset, #custom-rebuild, #bluetooth, #temperature, #memory, #window, #pulseaudio, #wireplumber" = {
        padding = mkLiteral "0px 5px";
      };

      "#custom-wlsunset,\n    #battery,\n    #network,\n    #backlight,\n    #idle_inhibitor" = {
        padding = mkLiteral "0px 5px";
      };

      "#mpris" = {
        padding = mkLiteral "0px 10px";
      };
      "#temperature.critical" = {
        color = mkLiteral "${c.base08}";
      };
      "#battery.charging" = {
        color = mkLiteral "${c.base0B}";
      };
      "#battery.warning:not(.charging)" = {
        color = mkLiteral "${c.base0A}";

      };
      "#battery.critical:not(.charging)" = {
        color = mkLiteral "${c.base08}";
      };
      "#wireplumber.muted" = {
        color = mkLiteral "${c.base03}";
      };
      "#pulseaudio.source-muted" = {
        color = mkLiteral "${c.base03}";
      };
    };
}

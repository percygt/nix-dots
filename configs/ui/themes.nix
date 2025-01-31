{
  pkgs,
  lib,
  config,
  ...
}:
let
  c = config.modules.themes.colors;
in
{
  home.packages = with pkgs; [
    adwaita-icon-theme
    yaru-theme
    hicolor-icon-theme
    humanity-icon-theme
    vivid
  ];
  home.sessionVariables = {
    # LS_COLORS = "$(${lib.getExe pkgs.vivid} generate ${config.modules.themes.vividTheme})";
    EZA_COLORS = "$(${lib.getExe pkgs.vivid} generate ${config.modules.themes.vividTheme})";
  };
  xdg = {
    configFile."vivid/themes/custom-vivid.yml".text = lib.concatStringsSep "\n" [
      ''
        colors:
          black: "${c.base01}"
          red: "${c.base08}"
          green: "${c.base0B}"
          yellow: "${c.base0A}"
          blue: "${c.base0D}"
          purple: "${c.base0E}"
          cyan: "${c.base0C}"
          orange: "${c.base09}"
          white: "${c.base07}"
          gray1: "${c.base0C}"
          gray2: "${c.base04}"
          bg: "${c.base00}"
          fg: "${c.base05}"
      ''
      (lib.readFile ./+extras/vivid-theme.yml)
    ];
    dataFile = {
      "themes/Yaru-dark".source = "${pkgs.yaru-theme}/share/themes/Yaru-dark";
      "themes/Yaru-bark".source = "${pkgs.yaru-theme}/share/themes/Yaru-bark";
      "themes/Yaru-bark-dark".source = "${pkgs.yaru-theme}/share/themes/Yaru-bark-dark";
      "icons/Yaru-dark".source = "${pkgs.yaru-theme}/share/icons/Yaru-dark";
      "icons/Yaru-bark".source = "${pkgs.yaru-theme}/share/icons/Yaru-bark";
      "icons/Yaru-bark-dark".source = "${pkgs.yaru-theme}/share/icons/Yaru-bark-dark";
      "icons/Adwaita".source = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita";
      "icons/hicolor".source = "${pkgs.hicolor-icon-theme}/share/icons/hicolor";
      "icons/Humanity".source = "${pkgs.humanity-icon-theme}/share/icons/Humanity";
    };
  };
}

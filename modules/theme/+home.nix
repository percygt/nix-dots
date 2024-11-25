{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  c = config.modules.theme.colors;
in
{
  imports = [
    inputs.base16.homeManagerModule
  ];
  config = lib.mkIf config.modules.theme.enable {
    scheme = config.modules.theme.colorscheme;
    modules.theme.colors = config.scheme;
    home.packages = with pkgs; [
      adwaita-icon-theme
      yaru-theme
      hicolor-icon-theme
      humanity-icon-theme
    ];
    home.sessionVariables = {
      LS_COLORS = "$(${lib.getExe pkgs.vivid} generate ${config.modules.theme.vividTheme})";
      EZA_COLORS = "$(${lib.getExe pkgs.vivid} generate ${config.modules.theme.vividTheme})";
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
            white: "${c.base05}"
            grey: "${c.base03}"
        ''
        (lib.readFile ./vivid-theme.yml)
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
  };
}

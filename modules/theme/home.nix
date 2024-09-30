{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./module.nix
    inputs.base16.homeManagerModule
  ];
  config = {
    scheme = config.modules.theme.colorscheme;
    xdg = {
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

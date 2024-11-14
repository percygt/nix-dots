{ pkgs, ... }:
{
  home.packages = with pkgs; [ lollypop ];
  xdg.mimeApps.defaultApplications."audio/*" = [ "org.gnome.Lollypop.desktop" ];
}

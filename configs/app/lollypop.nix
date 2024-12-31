{ pkgs, ... }:
{
  home.packages = with pkgs; [ lollypop ];
  xdg.mimeApps.defaultApplications."audio/*" = [ "org.gnome.Lollypop.desktop" ];
  xdg.mimeApps.associations.added."audio/*" = [ "org.gnome.Lollypop.desktop" ];
}

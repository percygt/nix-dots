{ pkgs, ... }:
{
  home.packages = with pkgs; [ loupe ];
  xdg.mimeApps.defaultApplications."image/*" = [ "org.gnome.Loupe.desktop" ];
  xdg.mimeApps.associations.added."image/*" = [ "org.gnome.Loupe.desktop" ];
}

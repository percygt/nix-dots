{ pkgs, ... }:
{
  home.packages = with pkgs; [ loupe ];
  xdg.mimeApps.defaultApplications."image/*" = [ "org.gnome.Loupe.desktop" ];
}

{ pkgs, ... }:
{
  home.packages = with pkgs; [ lollypop ];
  xdg.mimeApps.defaultApplications."audio/*" = [ "lollypop.desktop" ];
}

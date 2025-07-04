{ pkgs, username, ... }:
{
  # X11

  services.xserver = {
    enable = true;
    videoDrivers = [ "qxl" ];
    # Desktop environment
    desktopManager.lxqt = {
      enable = true;
    };

    xserver.displayManager = {
      autoLogin.user = username;
    };
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}

{ pkgs, username, ... }:
{
  # X11

  services.xserver = {
    enable = true;
    videoDrivers = [ "qxl" ];
    # Desktop environment
    desktopManager.xfce = {
      enableScreensaver = false;
      enable = true;
    };

    displayManager = {
      autoLogin.user = username;
      # lightdm = {
      #   enable = true;
      # };
      # startx.enable = true;
    };
    #
    # excludePackages = with pkgs; [
    #   xterm
    # ];
    #
    # exportConfiguration = true;
    #
    # xkb.layout = "us";
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}

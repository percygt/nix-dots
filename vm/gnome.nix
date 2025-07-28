{ username, pkgs, ... }:
{
  services = {
    sshd.enable = true;
    gvfs.enable = true;
    xserver = {
      enable = true;
      videoDrivers = [ "qxl" ];
    };
    gnome = {
      gnome-keyring.enable = true;
      sushi.enable = true;
    };
    libinput.enable = true;
    libinput.touchpad.tapping = true; # tap
    displayManager = {
      gdm.enable = true;
      gdm.wayland = false;
      autoLogin.user = username;
      defaultSession = "gnome";
    };
    desktopManager.gnome.enable = true;
  };
  programs.dconf.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}

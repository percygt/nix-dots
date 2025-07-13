{ username, ... }:
{

  # X configuration
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";

  services.displayManager.autoLogin.user = username;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.desktopManager.xfce.enableScreensaver = false;

  services.xserver.videoDrivers = [ "qxl" ];
  # Enable ssh
  services.sshd.enable = true;
  # services = {
  #   flatpak.enable = true;
  #   gvfs.enable = true;
  #   sushi.enable = true;
  #   gnome = {
  #     gnome-keyring.enable = true;
  #   };
  #   xserver = {
  #     enable = true;
  #     excludePackages = with pkgs; [
  #       xterm
  #     ];
  #     displayManager = {
  #       lightdm = {
  #         enable = true;
  #       };
  #     };
  #     desktopManager.xfce.enable = true;
  #     libinput.enable = true;
  #     libinput.touchpad.tapping = true; # tap
  #   };
  # };
  #
  # environment.systemPackages = with pkgs; [
  #   wmctrl
  #   xclip
  #   xcolor
  #   xcolor
  #   xdo
  #   xdotool
  #   xfce.catfish
  #   xfce.gigolo
  #   xfce.orage
  #   xfce.xfburn
  #   xfce.xfce4-appfinder
  #   xfce.xfce4-clipman-plugin
  #   xfce.xfce4-cpugraph-plugin
  #   xfce.xfce4-dict
  #   xfce.xfce4-fsguard-plugin
  #   xfce.xfce4-genmon-plugin
  #   xfce.xfce4-netload-plugin
  #   xfce.xfce4-panel
  #   xfce.xfce4-pulseaudio-plugin
  #   xfce.xfce4-systemload-plugin
  #   xfce.xfce4-weather-plugin
  #   xfce.xfce4-whiskermenu-plugin
  #   xfce.xfce4-xkb-plugin
  #   xfce.xfdashboard
  #   xorg.xev
  #   xsel
  #   xtitle
  #   xwinmosaic
  # ];
}

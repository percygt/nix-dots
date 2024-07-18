{ config, ... }:
{
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-theme = config.gtk.cursorTheme.name;
      gtk-theme = config.gtk.theme.name;
      icon-theme = config.gtk.iconTheme.name;
    };
    "org/nemo/window-state" = {
      start-with-menu-bar = false;
    };
  };
}

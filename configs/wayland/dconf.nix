{ config, ... }:
{
  dconf.settings = {
    "org/gnome/desktop/wm/preferences".button-layout = ":appmenu";
    "org/gnome/terminal/legacy".default-show-menubar = false;
    "org/cinnamon/desktop/default-applications/terminal".exec = "foot";
    "org/cinnamon/desktop/default-applications/terminal".exec-arg = "";
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

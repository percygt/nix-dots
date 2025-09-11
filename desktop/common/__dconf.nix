{ config }:
let
  inherit (config.modules.themes)
    cursorTheme
    iconTheme
    gtkTheme
    ;
in
{
  "org/gnome/desktop/wm/preferences".button-layout = ":appmenu";
  "org/gnome/terminal/legacy".default-show-menubar = false;
  "org/cinnamon/desktop/default-applications/terminal".exec = config._base.terminal.defaultCmd;
  "org/cinnamon/desktop/default-applications/terminal".exec-arg = "";
  "org/virt-manager/virt-manager/connections" = {
    autoconnect = [ "qemu:///system" ];
    uris = [ "qemu:///system" ];
  };
  "org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    cursor-theme = cursorTheme.name;
    gtk-theme = gtkTheme.name;
    icon-theme = iconTheme.name;
  };
  "org/nemo/window-state" = {
    start-with-menu-bar = false;
  };
}

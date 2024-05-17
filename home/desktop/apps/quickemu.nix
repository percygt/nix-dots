{
  pkgs,
  config,
  lib,
  ...
}: {
  xdg = {
    configFile."spicy/settings".text = lib.generators.toINI {} {
      general = {
        grab-keyboard = true;
        grab-mouse = true;
        scaling = true;
        auto-clipboard = true;
        sync-modifiers = true;
        resize-guest = true;
        auto-usbredir = true;
      };
      ui = {
        toolbar = false;
        statusbar = false;
      };
    };
    desktopEntries."quickemu-win10" = {
      name = "Windows 10";
      exec = "${pkgs.quickemu}/bin/quickemu --vm windows-10.conf --display spice";
      terminal = false;
      icon = "qemu";
      settings = {
        Path = "${config.home.homeDirectory}/windows";
      };
      type = "Application";
    };
  };
}

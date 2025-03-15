{
  lib,
  config,
  ...
}:
let
  g = config._base;
  kvmEnable = config.modules.virtualisation.kvm.enable;
in
{
  xdg = lib.mkIf kvmEnable {
    configFile."spicy/settings".text = lib.generators.toINI { } {
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
    desktopEntries."quickemu-win10" = lib.mkIf kvmEnable {
      name = "Windows 10";
      exec = "quickemu --vm ${g.windowsDirectory}/windows-10.conf --display spice";
      terminal = false;
      icon = "qemu";
      type = "Application";
    };
  };
}

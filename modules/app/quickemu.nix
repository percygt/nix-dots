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
    desktopEntries."quickemu-win11" = lib.mkIf kvmEnable {
      name = "Windows 11";
      exec = "quickemu --vm ${g.windowsDirectory}/windows-11.conf --display spice --public-dir ${g.windowsDirectory}/sharedData";
      terminal = false;
      icon = "qemu";
      type = "Application";
    };
  };
}

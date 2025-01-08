{
  pkgs,
  config,
  lib,
  ...
}:
let
  swayCfg = config.wayland.windowManager.sway;
  nautilus = pkgs.writers.writeBash "nautilus-file-manager" ''
    nautilus ~
  '';
  mod = swayCfg.config.modifier;
in
{
  imports = [
    ./quickemu.nix
  ];
  wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
    "${mod}+shift+f" = "exec ddapp -t 'org.gnome.Nautilus' -c ${nautilus}";
    XF86Calculator = "exec ddapp -t 'org.gnome.Calculator' -c gnome-calculator";
  };
  modules.desktop.sway.floatingRules = [
    {
      command = ''resize set width 30ppt height 60ppt, move position center'';
      criterias = [ { app_id = "org.gnome.Calculator"; } ];
    }
    {
      command = ''resize set width 90ppt height 90ppt, move position center'';
      criterias = [
        { app_id = "org.gnome.Shotwell"; }
        { app_id = "org.gnome.Snapshot"; }
        { app_id = "mpv"; }
      ];
    }
    {
      command = ''resize set width 80ppt height 80ppt, move position center'';
      criterias = [
        { app_id = "gnome-disks"; }
        { app_id = "lollypop"; }
        { app_id = "io.github.dvlv.boxbuddyrs"; }
        { app_id = "org.gnome.Firmware"; }
      ];
    }
  ];
  xdg.configFile."swayimg/config".source = ./+assets/swayimgrc;
  xdg.mimeApps = {
    defaultApplications = import ./mimeApps.nix;
    associations.added = import ./mimeApps.nix;
  };
  home.packages = with pkgs; [
    swayimg # default image viewer
    mpv # default video player
    zathura # default pdf viewer
    lollypop # default audio player
    gnome-calculator
    gnome-firmware
    shotwell
    snapshot
    font-manager
    coulr
    pinta
    # foliate
    # gimp
    # logseq
    # lutris
  ];
}

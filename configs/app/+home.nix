{
  pkgs,
  ...
}:
{
  imports = [
    ./quickemu.nix
  ];

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
  xdg.mimeApps = {
    defaultApplications = import ./mimeApps.nix;
    associations.added = import ./mimeApps.nix;
  };
  home.packages = with pkgs; [
    swayimg
    gapless
    mpv # default video player
    # loupe # default image viewer
    zathura # default pdf viewer
    lollypop # default audio player
    gnome-calculator
    gnome-firmware
    shotwell
    snapshot
    font-manager
    coulr
    pinta
    boxbuddy
    # foliate
    # gimp
    # logseq
    # lutris
  ];
}

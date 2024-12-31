{
  pkgs,
  ...
}:
{
  imports = [
    ./loupe.nix
    ./mpv.nix
    ./quickemu.nix
    ./zathura.nix
    ./lollypop.nix
  ];

  modules.desktop.sway.floatingRules = [
    {
      command = ''resize set width 30ppt height 60ppt, move position center'';
      criterias = [ { app_id = "org.gnome.Calculator"; } ];
    }
    {
      command = ''resize set width 80ppt height 80ppt, move position center'';
      criterias = [
        { app_id = "gnome-disks"; }
        { app_id = "org.gnome.Nautilus"; }
        { app_id = "org.gnome.Snapshot"; }
        { app_id = "io.github.dvlv.boxbuddyrs"; }
        { app_id = "org.gnome.Shotwell"; }
        { app_id = "org.gnome.Firmware"; }
      ];
    }
  ];
  home.packages = with pkgs; [
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

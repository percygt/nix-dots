{pkgs, ...}: {
  services = {
    # needed for GNOME services outside of GNOME Desktop
    dbus = {
      enable = true;
      packages = with pkgs; [
        gcr
        gnome.gnome-settings-daemon
      ];
      implementation = "broker";
    };
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    pcscd.enable = true;
    udisks2.enable = true;
    fwupd.enable = true;
  };
}

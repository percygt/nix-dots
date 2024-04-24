{pkgs, ...}: {
  services.flatpak.enable = true;
  systemd.services.flatpak-setup-flathub = {
    wantedBy = ["multi-user.target"];
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
  fileSystems = {
    "/var/lib/flatpak".options = ["exec"];
  };
}

{pkgs, ...}: {
  services.supergfxd.enable = true;
  systemd.services.supergfxd.path = [pkgs.pciutils];
}

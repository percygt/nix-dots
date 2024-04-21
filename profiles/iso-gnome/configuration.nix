{
  pkgs,
  lib,
  inputs,
  username,
  outputs,
  self,
  ...
}: {
  imports = [
    {isoImage.squashfsCompression = "gzip -Xcompression-level 1";}
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    "${self}/system/core/packages.nix"
    "${self}/system/common"
    "${self}/system/bin/installer.nix"
  ];

  core.packages.enable = true;

  systemd.services."home-manager-${username}" = {
    before = ["display-manager.service"];
    wantedBy = ["multi-user.target"];
  };

  nixpkgs.overlays = builtins.attrValues outputs.overlays;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services = {
    udisks2.enable = true;
    openssh.settings.PermitRootLogin = lib.mkForce "yes";
  };
}

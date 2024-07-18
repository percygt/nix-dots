{ lib, ... }:
{
  imports = [
    ./ssh
    ./gpg
    ./sops
    ./keepass
    ./common.nix
  ];

  infosec = {
    gpg.home.enable = lib.mkDefault true;
    gpg.pass.enable = lib.mkDefault true;
    ssh.home.enable = lib.mkDefault true;
    sops.home.enable = lib.mkDefault true;
  };
}

{ lib, ... }:
{
  imports = [
    ./ssh
    ./gpg
    ./sops
    ./keepass
    ./common.nix
  ];

  modules.security = {
    gpg.enable = lib.mkDefault true;
    gpg.pass.enable = lib.mkDefault true;
    ssh.enable = lib.mkDefault true;
    sops.enable = lib.mkDefault true;
  };
}

{ lib, username, ... }:
{
  imports = [
    ./sops
    ./ssh
    ./gpg
    ./keepass
    ./hardening.nix
    ./kernel.nix
    ./backup.nix
    ./fprintd.nix
  ];

  modules.security = {
    backup.enable = lib.mkDefault true;
    keepass.enable = lib.mkDefault true;
    sops.enable = lib.mkDefault true;
    gpg.enable = lib.mkDefault true;
    ssh.enable = lib.mkDefault true;
    kernel.enable = lib.mkDefault true;
  };

  home-manager.users.${username} = {
    imports = [ ./common.nix ];
    modules.security.common.enable = lib.mkDefault true;
  };
}

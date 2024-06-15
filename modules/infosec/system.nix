{
  lib,
  username,
  ...
}: {
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

  infosec = {
    backup.system.enable = lib.mkDefault true;
    keepass.system.enable = lib.mkDefault true;
    sops.system.enable = lib.mkDefault true;
    gpg.system.enable = lib.mkDefault true;
    ssh.system.enable = lib.mkDefault true;
    kernel.system.enable = lib.mkDefault true;
  };

  home-manager.users.${username} = {
    imports = [./common.nix];
    infosec.common.home.enable = lib.mkDefault true;
  };
}

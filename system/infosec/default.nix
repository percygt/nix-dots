{lib, ...}: {
  imports = [
    ./sops.nix
    ./ssh.nix
    ./gpg.nix
    ./hardening.nix
    ./kernel.nix
    ./backup.nix
  ];

  infosec = {
    backup.enable = lib.mkDefault true;
    sops.enable = lib.mkDefault true;
    gpg.enable = lib.mkDefault true;
    ssh.enable = lib.mkDefault true;
    hardening.enable = lib.mkDefault true;
    kernel.enable = lib.mkDefault true;
  };
}

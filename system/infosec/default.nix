{lib, ...}: {
  imports = [
    ./sops.nix
    ./ssh.nix
    ./gpg.nix
    ./hardening.nix
    ./kernel.nix
  ];

  infosec = {
    sops.enable = lib.mkDefault true;
    gpg.enable = lib.mkDefault true;
    ssh.enable = lib.mkDefault true;
    hardening.enable = lib.mkDefault true;
    kernel.enable = lib.mkDefault true;
  };
}

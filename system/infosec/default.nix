{lib, ...}: {
  imports = [
    ./sops.nix
    ./ssh.nix
    ./gpg.nix
  ];

  infosec = {
    sops.enable = lib.mkDefault true;
    gpg.enable = lib.mkDefault true;
    ssh.enable = lib.mkDefault true;
  };
}

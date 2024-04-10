{lib, ...}: {
  imports = [
    ./sops.nix
    ./ssh.nix
  ];

  infosec = {
    sops.enable = lib.mkDefault true;
    ssh.enable = lib.mkDefault true;
  };
}

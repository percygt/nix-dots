{lib, ...}: {
  imports = [
    ./ssh.nix
    ./gpg.nix
    ./backup.nix
    ./pass.nix
    ./keepass.nix
    ./common.nix
    ./sops.nix
    ./kpass.nix
    ./pmenu.nix
  ];

  infosec = {
    gpg.enable = lib.mkDefault true;
    ssh.enable = lib.mkDefault true;
    sops.enable = lib.mkDefault true;
  };
}

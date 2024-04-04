{lib, ...}: {
  imports = [
    ./gpg.nix
    ./ssh.nix
  ];
  userModules = {
    gpg.enable = lib.mkDefault true;
    ssh.enable = lib.mkDefault true;
  };
}

{lib, ...}: {
  imports = [
    ./git
    ./gpg.nix
    ./ssh.nix
  ];

  userModules = {
    git = {
      enable = lib.mkDefault true;
      ghq.enable = lib.mkDefault true;
    };
    gpg.enable = lib.mkDefault true;
    ssh.enable = lib.mkDefault true;
  };
}

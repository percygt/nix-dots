{lib, ...}: {
  imports = [
    ./git
    ./gpg.nix
    ./ssh.nix
  ];

  userModules = {
    git = {
      enable = lib.mkDefault true;
      gh.enable = lib.mkDefault true;
      ghq.enable = lib.mkDefault true;
      glab.enable = lib.mkDefault true;
      credentials.enable = lib.mkDefault true;
    };
    gpg.enable = lib.mkDefault true;
    ssh.enable = lib.mkDefault true;
  };
}

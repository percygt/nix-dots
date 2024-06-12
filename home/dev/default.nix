{lib, ...}: {
  imports = [
    ./git
    ./go.nix
    ./common.nix
    ./jujutsu.nix
  ];

  dev = {
    git.enable = lib.mkDefault true;
  };
}

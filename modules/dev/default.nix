{lib, ...}: {
  imports = [
    ./git
    ./go.nix
    ./common.nix
  ];

  dev = {
    git.enable = lib.mkDefault true;
  };
}

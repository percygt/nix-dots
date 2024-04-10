{lib, ...}: {
  imports = [
    ./git
    ./go.nix
  ];

  dev = {
    git.enable = lib.mkDefault true;
  };
}

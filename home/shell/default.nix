{lib, ...}: {
  imports = [
    ./bash.nix
    ./fish.nix
  ];

  shell = {
    fish.enable = lib.mkDefault true;
    bash.enable = lib.mkDefault true;
  };
}

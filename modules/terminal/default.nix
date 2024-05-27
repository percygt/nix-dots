{lib, ...}: {
  imports = [
    ./foot.nix
    ./wezterm.nix
    ./kitty.nix
  ];

  terminal = {
    foot.enable = lib.mkDefault true;
  };
}

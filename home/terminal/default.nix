{lib, ...}: {
  imports = [
    ./foot.nix
    ./wezterm.nix
  ];

  terminal = {
    foot.enable = lib.mkDefault true;
  };
}

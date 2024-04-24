{
  inputs,
  homeDirectory,
}: {
  colors =
    (import ./colors.nix)
    // inputs.nix-colors.lib;
  fonts = import ./fonts.nix;
  wallpaper = "${homeDirectory}/.local/share/backgrounds/nice-mountain.jpg";
  sway = import ./sway.nix;
  toRasi = import ./toRasi.nix {inherit (inputs.nixpkgs) lib;};
  mkFileList = dir: builtins.attrNames (builtins.readDir dir);
}

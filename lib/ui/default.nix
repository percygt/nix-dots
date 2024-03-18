{pkgs, ...}: rec {
  colors = import ./colors.nix;
  themes = import ./themes.nix {inherit pkgs colors;};
  fonts = import ./fonts.nix {inherit pkgs;};
}

{
  inputs,
  homeDirectory ? "~",
  username,
  isGeneric,
}: let
  inherit (inputs.nixpkgs) lib;
in rec {
  inherit (import ../../packages/args.nix) clj;
  corePackages = pkgs: import ../../packages/corePackages.nix {inherit pkgs;};
  nixpkgsConfig = import ./nixpkgsConfig.nix;
  colors = (import ./colors.nix) // inputs.nix-colors.lib;
  fonts = import ./fonts.nix;
  wallpaper = "${homeDirectory}/.local/share/backgrounds/old-factory.jpg";
  sway = import ./sway.nix {inherit lib;};
  toRasi = import ./toRasi.nix {inherit lib;};
  mkLiteral = value: {
    _type = "literal";
    inherit value;
  };

  gtkPackage = pkgs: pkgs.colloid-gtk-theme;

  cursorTheme = {
    name = "phinger-cursors-light";
    package = pkgs: pkgs.phinger-cursors;
    x-scaling = 1.0;
    size = 32;
  };

  iconTheme = {
    name = "Papirus-Dark";
    package = pkgs: pkgs.catppuccin-papirus-folders;
  };

  gtkTheme = {
    name = "Colloid-Dark-Nord";
    package = gtkPackage;
  };

  gnomeShellTheme = {
    name = "Colloid-Dark-Nord";
    package = gtkPackage;
  };
}

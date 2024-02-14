{pkgs}: let
  gitd = import ./gitd.nix {inherit pkgs;};
  preview = import ./preview.nix {inherit pkgs;};
in {
  home.packages = [
    gitd
    preview
  ];
}

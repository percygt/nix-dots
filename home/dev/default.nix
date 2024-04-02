{pkgs, ...}: {
  imports = [./go.nix];
  home.packages = with pkgs; [
    ghidra
  ];
}

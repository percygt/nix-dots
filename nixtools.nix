{
  pkgs,
  inputs,
  ...
}:
# nix tooling
{
  home.packages = with pkgs; [
    alejandra
    deadnix
    statix
    nurl
    nix-tree
    node2nix
    nix-your-shell
  ];
  # home.file = {
  #   # Put the pre-generated nix-index database in place,
  #   # used for command-not-found.
  #   ".cache/nix-index/files".source =
  #     inputs.nix-index-database.legacyPackages.${pkgs.system}.database;
  # };

  programs.nix-index = {
    enable = true;
  };
}

{
  pkgs,
  username,
  config,
  inputs,
  ...
}:
let
  g = config._global;
in
{
  imports = [ inputs.nix-index-database.homeModules.nix-index ];
  home.packages = with pkgs; [
    nixos-shell
    # devenv
    nixfmt-rfc-style
    deadnix
    statix
    nurl
    nix-tree
    nix-your-shell
    cachix
    json2nix
    nix-output-monitor
    nvd
    omnix
    nix-search-cli
    nix-inspect
    nix-prefetch-scripts
    nix-prefetch-github
    noogle-cli
  ];
  programs = {
    nh = {
      enable = true;
      flake = g.system.envVars.FLAKE;
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 3";
      };
    };
    nix-index-database.comma.enable = true;
    nix-init = {
      enable = true;
      settings = {
        maintainers = [ username ];
        commit = true;
        nixpkgs = "<nixpkgs>";
      };
    };
  };
}

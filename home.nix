{
  username,
  pkgs,
  lib,
  ...
}: let
  homeDirectory = "/home/${username}";
  commonConfig = builtins.fromTOML (builtins.readFile ./common/config.toml);
in {
  imports =
    [
      ./program
      ./nixtools.nix
      ./cli.nix
      ./fonts.nix
      ./bin
    ]
    ++ lib.optional (builtins.pathExists ./nix-personal) ./nix-personal;
  news.display = "silent";

  targets.genericLinux.enable = true;

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      auto-optimise-store = true;
      warn-dirty = false;
      bash-prompt-prefix = "(nix:$name)\\040";
      max-jobs = "auto";
      extra-nix-path = "nixpkgs=flake:nixpkgs";
      substituters = [
        "https://cache.nixos.org"
        "https://percygtdev.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "percygtdev.cachix.org-1:AGd4bI4nW7DkJgniWF4tS64EX2uSYIGqjZih2UVoxko="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  home = {
    inherit username homeDirectory;
    shellAliases = commonConfig.aliases;
    sessionVariables = commonConfig.variables;
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}

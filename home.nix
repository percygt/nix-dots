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
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      warn-dirty = false;
      bash-prompt-prefix = "(nix:$name)\\040";
      max-jobs = "auto";
      extra-nix-path = "nixpkgs=flake:nixpkgs";
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

{
  username,
  pkgs,
  homeDirectory,
  stateVersion,
  flakeDirectory,
  lib,
  inputs,
  config,
  ...
}: let
  defaultShellAliases = import ../lib/aliases.nix;
  defaultSessionVariables = import ../lib/variables.nix;
in {
  imports = [
    ./.
  ];
  news.display = "silent";
  targets.genericLinux.enable = true;
  home = {
    inherit
      username
      homeDirectory
      stateVersion
      ;
  };
  home.shellAliases =
    defaultShellAliases
    // {
      hms = "home-manager switch --flake ${flakeDirectory}'?submodules=1#'home@$hostname";
    };
  home.sessionVariables =
    defaultSessionVariables
    // {
      FLAKE_PATH = flakeDirectory;
      QT_QPA_PLATFORM = "xcb;wayland";
      QT_STYLE_OVERRIDE = "kvantum";
      GTK_THEME = "Colloid-Dark-Nord";
      GTK_CURSOR = "Colloid-dark-cursors";
      XCURSOR_THEME = "Colloid-dark-cursors";
      GTK_ICON = "Win11";
    };
  nix = {
    package = pkgs.nix;
    # pin the registry to avoid downloading and evaling a new nixpkgs version every time
    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;
    # set the path for channels compat
    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
    settings = {
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      builders-use-substitutes = true;
      flake-registry = "/etc/nix/registry.json";
      auto-optimise-store = true;
      warn-dirty = false;
      bash-prompt-prefix = "(nix:$name)\\040";
      max-jobs = "auto";
      trusted-users = ["@wheel" "root"];
      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;
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
}

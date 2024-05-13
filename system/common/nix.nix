{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: {
  nix = {
    package = lib.mkDefault pkgs.nixVersions.git;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      builders-use-substitutes = true;
      auto-optimise-store = true;
      warn-dirty = false;
      max-jobs = "auto";
      trusted-users = ["@wheel" "root"];
      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;
      substituters = [
        "https://percygtdev.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "percygtdev.cachix.org-1:AGd4bI4nW7DkJgniWF4tS64EX2uSYIGqjZih2UVoxko="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    gc = {
      automatic = true;
      dates = "Sun";
    };

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mkForce (lib.mapAttrs (_: value: {flake = value;}) inputs);

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mkForce (lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry);

    optimise.automatic = true;
  };
}

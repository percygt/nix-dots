{ lib, ... }:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
        "auto-allocate-uids"
      ];
      use-xdg-base-directories = true;
      builders-use-substitutes = true;
      auto-optimise-store = lib.mkDefault true;
      warn-dirty = false;
      trusted-users = [
        "@wheel"
        "root"
      ];
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = "nixpkgs=flake:nixpkgs";
      keep-outputs = true;
      # Do not create a bunch of nixbld users
      auto-allocate-uids = true;
      max-jobs = "auto";
      # http-connections = 128;
      # max-substitution-jobs = 128;
      trusted-substituters = [
        "https://percygtdev.cachix.org"
        "https://nix-community.cachix.org"
      ];
      extra-substituters = lib.mkAfter [
        "https://percygtdev.cachix.org"
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "percygtdev.cachix.org-1:AGd4bI4nW7DkJgniWF4tS64EX2uSYIGqjZih2UVoxko="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}

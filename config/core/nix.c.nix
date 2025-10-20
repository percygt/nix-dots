{
  lib,
  inputs,
  pkgs,
  ...
}:
let
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in
{
  # nix = {
  #   settings = {
  #     experimental-features = [
  #       "pipe-operators"
  #       "nix-command"
  #       "flakes"
  #       "ca-derivations"
  #       "auto-allocate-uids"
  #     ];
  #     accept-flake-config = false;
  #     use-xdg-base-directories = true;
  #     auto-optimise-store = true;
  #     warn-dirty = false;
  #     trusted-users = [
  #       "root"
  #       "@wheel"
  #     ];
  #     flake-registry = ""; # Disable global flake registry
  #     keep-outputs = true;
  #     nix-path = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  #
  #     # Do not create a bunch of nixbld users
  #     auto-allocate-uids = true;
  #     max-jobs = "auto";
  #     substituters = [ "https://cache.nixos.org" ];
  #     trusted-substituters = [
  #       "https://percygtdev.cachix.org"
  #       "https://nix-community.cachix.org"
  #     ];
  #     extra-substituters = lib.mkAfter [
  #       "https://percygtdev.cachix.org"
  #       "https://nix-community.cachix.org"
  #     ];
  #     extra-trusted-public-keys = [
  #       "percygtdev.cachix.org-1:AGd4bI4nW7DkJgniWF4tS64EX2uSYIGqjZih2UVoxko="
  #       "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  #     ];
  #   };
  # };
  nix = {
    settings = {
      experimental-features = [
        "pipe-operators"
        "nix-command"
        "flakes"
        "ca-derivations"
        "auto-allocate-uids"
      ];
      use-xdg-base-directories = true;
      warn-dirty = false;
      trusted-users = [
        "@wheel"
        "percygt"
        "root"
      ];
      connect-timeout = 5;
      min-free = 128000000; # 128MB
      max-free = 1000000000; # 1GB
      builders-use-substitutes = true;
      fallback = true; # Don't hard fail if a binary cache isn't available, since some systems roam
      nix-path = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

      # Do not create a bunch of nixbld users
      auto-allocate-uids = true;
      max-jobs = "auto";
      substituters = [
        "https://percygtdev.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "percygtdev.cachix.org-1:AGd4bI4nW7DkJgniWF4tS64EX2uSYIGqjZih2UVoxko="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}

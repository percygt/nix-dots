{
  lib,
  inputs,
  ...
}:
let
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in
{
  nix.settings = {
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
    keep-outputs = true;
    builders-use-substitutes = true;
    # fallback = true; # Don't hard fail if a binary cache isn't available, since some systems roam
    nix-path = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

    # Do not create a bunch of nixbld users
    auto-allocate-uids = true;
    max-jobs = "auto";
    substituters = [
      "https://percygtdev.cachix.org"
      "https://nix-community.cachix.org"
      "https://pre-commit-hooks.cachix.org"
      "https://watersucks.cachix.org"
    ];
    trusted-public-keys = [
      "percygtdev.cachix.org-1:AGd4bI4nW7DkJgniWF4tS64EX2uSYIGqjZih2UVoxko="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
      "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="
    ];
  };
}

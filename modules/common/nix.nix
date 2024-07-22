{ lib, pkgs, ... }:
{
  nix = {
    package = lib.mkDefault pkgs.nixVersions.git;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      warn-dirty = false;
      max-jobs = "auto";
      trusted-users = [
        "@wheel"
        "root"
      ];
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
  };
}

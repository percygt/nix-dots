{
  lib,
  libx,
  username,
  config,
  ...
}: let
  cfg = config.shell;
  modules = [./bash.nix ./fish.nix];
in
  libx.importModules {inherit modules cfg;}
  // {
    options = {
      shell = {
        fish.enable = lib.mkOption {
          description = "Enable fish";
          default = true;
          type = lib.types.bool;
        };
        bash.enable = lib.mkOption {
          description = "Enable bash";
          default = true;
          type = lib.types.bool;
        };
      };
    };
  }

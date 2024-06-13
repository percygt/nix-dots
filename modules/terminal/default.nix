{
  lib,
  libx,
  username,
  config,
  ...
}: let
  cfg = config.terminal;
  modules = [./wezterm.nix ./foot.nix ./kitty.nix];
in
  libx.importModules {inherit modules cfg;}
  // {
    options = {
      terminal = {
        foot.enable = lib.mkOption {
          description = "Enable fish";
          default = true;
          type = lib.types.bool;
        };
        kitty.enable = lib.mkEnableOption "Enable kitty";
        wezterm.enable = lib.mkEnableOption "Enable wezterm";
      };
    };
  }

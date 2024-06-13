{
  lib,
  libx,
  username,
  config,
  ...
}: let
  modules = [
    ./atuin.nix
    ./direnv.nix
    ./extra.nix
    ./starship.nix
    ./aria.nix
    ./ncmpcpp.nix
    ./tui.nix
    ./yazi

    ./common.nix
    ./bat.nix
    ./eza.nix
    ./nixtools.nix
    ./tmux
  ];
  cfg = config.cli;
in
  libx.importModules {inherit modules cfg;}
  // {
    options = {
      cli = {
        atuin.enable = lib.mkEnableOption "Enable atuin";
        direnv.enable = lib.mkEnableOption "Enable direnv";
        extra.enable = lib.mkEnableOption "Enable extra";
        starship.enable = lib.mkEnableOption "Enable starship";
        aria.enable = lib.mkEnableOption "Enable aria";
        ncmpcpp.enable = lib.mkEnableOption "Enable ncmpcpp";
        tui.enable = lib.mkEnableOption "Enable tui";
        yazi.enable = lib.mkEnableOption "Enable yazi";
        common.enable = lib.mkOption {
          description = "Enable common cli tools";
          default = true;
          type = lib.types.bool;
        };
        bat.enable = lib.mkOption {
          description = "Enable bat";
          default = true;
          type = lib.types.bool;
        };
        eza.enable = lib.mkOption {
          description = "Enable eza";
          default = true;
          type = lib.types.bool;
        };
        tmux.enable = lib.mkOption {
          description = "Enable tmux";
          default = true;
          type = lib.types.bool;
        };
        nixtools.enable = lib.mkOption {
          description = "Enable nixtools";
          default = true;
          type = lib.types.bool;
        };
      };
    };
  }

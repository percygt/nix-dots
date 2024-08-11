{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  g = config._general;
  cfg = config.modules.editor.emacs;
in
#
{
  options.modules.editor = {
    emacs.enable = lib.mkEnableOption "Enable emacs systemwide";
    emacs.package = lib.mkOption {
      description = "emacs package to use";
      default = pkgs.emacs-unstable;
      type = lib.types.package;
    };
  };
  config = lib.mkIf config.modules.editor.emacs.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];
    environment.systemPackages = [
      (pkgs.aspellWithDicts (
        dicts: with dicts; [
          en
          en-computers
        ]
      ))
    ];
    services.emacs = {
      enable = true;
      inherit (cfg) package;
      startWithGraphical = true;
    };
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${g.username} = {
          directories = [ ".local/share/emacs" ];
        };
      };
    };
    home-manager.users.${g.username} = {
      imports = [ ./home.nix ];
    };
  };
}

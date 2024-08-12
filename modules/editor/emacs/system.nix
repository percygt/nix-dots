{
  pkgs,
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
  imports = [ ./module.nix ];
  config = lib.mkIf cfg.enable {
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

{
  lib,
  config,
  ...
}:
let
  g = config._general;
  cfg = config.modules.editor.emacs;
in
{
  imports = [ ./module.nix ];
  config = lib.mkIf config.modules.editor.emacs.enable {
    home-manager.users.${g.username} = {
      imports = [ ./home.nix ];
      modules.editor.emacs.enable = lib.mkDefault true;
    };
    environment.systemPackages = [
      cfg.finalPackage
    ];
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${g.username} = {
          directories = [
            ".local/share/doom"
          ];
        };
      };
    };
  };
}

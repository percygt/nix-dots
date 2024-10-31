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

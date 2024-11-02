{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.modules.editor.emacs;
in
{
  # imports = [ ./module.nix ];
  config = lib.mkIf config.modules.editor.emacs.enable {
    environment.systemPackages = [
      cfg.finalPackage
    ];
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${username} = {
          directories = [
            ".local/share/doom"
          ];
        };
      };
    };
  };
}

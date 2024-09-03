{
  lib,
  config,
  ...
}:
let
  g = config._general;
  cfg = config.modules.security.gpg;
in
{
  imports = [ ./module.nix ];
  config = lib.mkIf config.modules.security.gpg.enable {
    environment.sessionVariables.SSH_AUTH_SOCK = lib.mkIf cfg.sshSupport.enable "${builtins.getEnv "XDG_RUNTIME_DIR"}/gnupg/S.gpg-agent.ssh";
    home-manager.users.${g.username} = import ./home.nix;
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist".users.${g.username}.directories = [
        {
          directory = ".gnupg";
          mode = "0700";
        }
      ];
    };
  };
}

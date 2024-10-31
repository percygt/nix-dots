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
    programs.gnupg.agent.enable = true;
    environment.sessionVariables.SSH_AUTH_SOCK = lib.mkIf cfg.sshSupport.enable cfg.sshSupport.authSock;
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

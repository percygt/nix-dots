{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.security.gpg;
in
{
  config = lib.mkIf config.modules.security.gpg.enable {
    programs.gnupg.agent.enable = true;
    environment.sessionVariables.SSH_AUTH_SOCK = lib.mkIf cfg.sshSupport.enable cfg.sshSupport.authSock;
    persistHome.directories = [
      {
        directory = ".gnupg";
        mode = "0700";
      }
    ];
  };
}

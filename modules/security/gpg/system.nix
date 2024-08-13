{
  lib,
  config,
  libx,
  ...
}:
let
  g = config._general;
in
{
  options.modules.security.gpg.enable = libx.enableDefault "gpg";
  config = lib.mkIf config.modules.security.gpg.enable {
    environment.sessionVariables.SSH_AUTH_SOCK = "/run/user/1000/gnupg/S.gpg-agent.ssh";
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

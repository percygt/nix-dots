{
  username,
  lib,
  config,
  libx,
  ...
}:
{
  options.modules.security.gpg.enable = libx.enableDefault "gpg";
  config = lib.mkIf config.modules.security.gpg.enable {
    home-manager.users.${username} = import ./home.nix;
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist".users.${username}.directories = [
        {
          directory = ".gnupg/private-keys-v1.d";
          mode = "0700";
        }
      ];
    };
  };
}

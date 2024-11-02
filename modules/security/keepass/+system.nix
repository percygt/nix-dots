{
  config,
  lib,
  username,
  ...
}:
{
  config = lib.mkIf config.modules.security.sops.enable {
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${username} = {
          directories = [ ".config/keepassxc" ];
        };
      };
    };
  };
}

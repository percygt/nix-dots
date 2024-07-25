{
  config,
  lib,
  username,
  ...
}:
{
  imports = [ ./module.nix ];
  config = lib.mkIf config.modules.dev.enable {
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${username} = {
          directories = [ ".config/gh" ];
        };
      };
    };
    home-manager.users.${username} = {
      imports = [ ./home.nix ];
      modules.dev.enable = lib.mkDefault true;
    };
  };
}

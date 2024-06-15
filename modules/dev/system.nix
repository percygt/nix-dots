{
  config,
  lib,
  username,
  ...
}: {
  config = lib.mkIf config.dev.system.enable {
    environment.persistence = lib.mkIf config.dev.persist.enable {
      "/persist" = {
        users.${username} = {
          directories = [
            ".config/gh"
          ];
        };
      };
    };
    home-manager.users.${username} = {
      imports = [./home.nix];
      dev.home.enable = lib.mkDefault true;
    };
  };
}

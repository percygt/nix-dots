{
  config,
  lib,
  username,
  libx,
  ...
}:
{
  options.modules.security.keepass.enable = libx.enableDefault "keepass";
  config = lib.mkIf config.modules.security.sops.enable {
    home-manager.users.${username} = import ./home.nix;
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${username} = {
          directories = [ ".config/keepassxc" ];
        };
      };
    };
  };
}

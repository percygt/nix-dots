{
  config,
  lib,
  libx,
  ...
}:
let
  g = config._general;
in
{
  options.modules.security.keepass.enable = libx.enableDefault "keepass";
  config = lib.mkIf config.modules.security.sops.enable {
    home-manager.users.${g.username} = import ./home.nix;
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${g.username} = {
          directories = [ ".config/keepassxc" ];
        };
      };
    };
  };
}

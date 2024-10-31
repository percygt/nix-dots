{
  config,
  lib,
  ...
}:
let
  g = config._general;
in
{

  imports = [ ./module.nix ];
  config = lib.mkIf config.modules.security.sops.enable {
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${g.username} = {
          directories = [ ".config/keepassxc" ];
        };
      };
    };
  };
}

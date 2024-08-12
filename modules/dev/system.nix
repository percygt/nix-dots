{ config, lib, ... }:
let
  g = config._general;
in
{
  imports = [ ./module.nix ];
  config = lib.mkIf config.modules.dev.enable {
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${g.username} = {
          directories = [ ];
        };
      };
    };
    home-manager.users.${g.username} = {
      imports = [ ./home.nix ];
      modules.dev.enable = lib.mkDefault true;
    };
  };
}

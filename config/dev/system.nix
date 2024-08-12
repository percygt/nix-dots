{ config, lib, ... }:
let
  g = config._general;
in
{
  home-manager.users.${g.username} = import ./home.nix;
  environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
    "/persist" = {
      users.${g.username} = {
        directories = [ ".config/gh" ];
      };
    };
  };
}

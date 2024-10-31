{
  pkgs,
  lib,
  config,
  ...
}:
let
  g = config._general;
in
{
  config = lib.mkIf config.modules.virtualisation.docker.enable {
    virtualisation.docker = {
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      enableOnBoot = false;
    };

    # Give access to the user
    users.users.${g.username}.extraGroups = [ "docker" ];

    # Include other utilities
    environment.systemPackages = with pkgs; [ docker-compose ];
  };
}

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
  # Enable the Docker service
  options.modules.virtualisation.docker.enable = lib.mkEnableOption "Enable docker";
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

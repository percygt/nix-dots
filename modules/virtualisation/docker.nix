{
  pkgs,
  username,
  lib,
  config,
  ...
}: {
  # Enable the Docker service
  options.virtual.docker.enable = lib.mkEnableOption "Enable docker";
  config = lib.mkIf config.virtual.docker.enable {
    virtualisation.docker = {
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      enableOnBoot = false;
    };

    # Give access to the user
    users.users.${username}.extraGroups = ["docker"];

    # Include other utilities
    environment.systemPackages = with pkgs; [
      docker-compose
    ];
  };
}

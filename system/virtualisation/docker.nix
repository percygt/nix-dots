{
  pkgs,
  username,
  ...
}: {
  # Enable the Docker service
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
}

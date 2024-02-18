{
  pkgs,
  username,
  ...
}: {
  # Enable the Docker service
  virtualisation.docker.enable = true;

  # Give access to the user
  users.users.${username}.extraGroups = ["docker"];

  # Include other utilities
  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}

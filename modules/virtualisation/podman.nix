{
  config,
  lib,
  ...
}: let
  dockerEnabled = config.virtualisation.docker.enable;
in {
  options.virtual.podman.enable = lib.mkEnableOption "Enable podman";
  config = lib.mkIf config.virtual.podman.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = !dockerEnabled;
      dockerSocket.enable = !dockerEnabled;
      defaultNetwork.settings.dns_enabled = true;
    };

    environment.persistence = {
      "/persist".directories = [
        "/var/lib/containers"
      ];
    };
  };
}

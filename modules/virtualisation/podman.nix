{ config, lib, ... }:
let
  dockerEnabled = config.modules.virtualisation.docker.enable;
in
{
  options.modules.virtualisation.podman.enable = lib.mkEnableOption "Enable podman";
  config = lib.mkIf config.modules.virtualisation.podman.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = !dockerEnabled;
      dockerSocket.enable = !dockerEnabled;
      defaultNetwork.settings.dns_enabled = true;
    };

    environment.persistence = {
      "/persist/system".directories = [ "/var/lib/containers" ];
    };
  };
}

{ config, lib, ... }:
let
  dockerEnabled = config.modules.virtualisation.docker.enable;
in
{
  config = lib.mkIf config.modules.virtualisation.podman.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = !dockerEnabled;
      dockerSocket.enable = !dockerEnabled;
      defaultNetwork.settings.dns_enabled = true;
    };

    persistSystem.directories = [ "/var/lib/containers" ];
  };
}

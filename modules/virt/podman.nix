{ config, lib, ... }:
let
  dockerEnabled = config.virt.docker.enable;
in
{
  options.virt.podman.enable = lib.mkEnableOption "Enable podman";
  config = lib.mkIf config.virt.podman.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = !dockerEnabled;
      dockerSocket.enable = !dockerEnabled;
      defaultNetwork.settings.dns_enabled = true;
    };

    environment.persistence = {
      "/persist".directories = [ "/var/lib/containers" ];
    };
  };
}

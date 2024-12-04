{
  lib,
  config,
  pkgs,
  ...
}:
{
  config =
    (lib.mkIf (
      config.modules.virtualisation.docker.enable || config.modules.virtualisation.podman.enable
    ))
      {
        environment.systemPackages = with pkgs; [
          cntr
          distrobox
          distrobox-tui
          boxbuddy
        ];
      };
}

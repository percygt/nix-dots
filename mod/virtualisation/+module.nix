{ lib, ... }:
{
  options.modules.virtualisation = {
    docker.enable = lib.mkEnableOption "Enable docker";
    kvm.enable = lib.mkEnableOption "Enable kvm";
    podman.enable = lib.mkEnableOption "Enable podman";
    vmvariant.enable = lib.mkEnableOption "Enable vmvariant";
    waydroid.enable = lib.mkEnableOption "Enable waydroid";
  };
}

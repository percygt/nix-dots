{username, ...}: let
  bridgeName = "br0";
in {
  imports = [
    ./kvm.nix
    ./docker.nix
    ./podman.nix
  ];
}

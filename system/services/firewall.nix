{ lib, hostName, ... }:
let
  # Firewall configuration variable for syncthing
  syncthing = {
    hosts = [
      "fates"
      "furies"
      "ivlivs"
    ];
    tcpPorts = [ 22000 ];
    udpPorts = [ 22000 21027 ];
  };
in
{
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = lib.optionals (builtins.elem hostName syncthing.hosts) syncthing.tcpPorts;
      allowedUDPPorts = lib.optionals (builtins.elem hostName syncthing.hosts) syncthing.udpPorts;
    };
  };
}

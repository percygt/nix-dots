{username, ...}: let
  bridgeName = "br0";
in {
  imports = [
    ./kvm.nix
    # ./docker.nix
    ./podman.nix
  ];

  networking.networkmanager.ensureProfiles.profiles.bridge = {
    connection = {
      id = bridgeName;
      type = "bridge";
      interface-name = bridgeName;
    };

    ipv4 = {
      method = "manual";
      address1 = "192.168.9.1/24";
    };
  };

  environment.etc."qemu/bridge.conf" = {
    user = "root";
    group = "qemu";
    mode = "0640";
    text = ''
      allow ${bridgeName}
    '';
  };

  users = {
    users.${username}.extraGroups = ["qemu"];
    groups.qemu = {};
  };

  # Add local DNS zone for VMs
  services.unbound.settings.server = {
    local-zone = ''"dev.local." redirect'';
    local-data = ''"dev.local. A 192.168.9.2"'';
  };
}

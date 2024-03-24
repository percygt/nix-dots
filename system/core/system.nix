{
  config,
  lib,
  username,
  ...
}: {
  options = {
    core.system = {
      enable =
        lib.mkEnableOption "Enable system services";
    };
  };

  config = lib.mkIf config.core.system.enable {
    services = {
      chrony.enable = true;
      journald.extraConfig = "SystemMaxUse=250M";
    };

    security = {
      polkit.enable = true;
      rtkit.enable = true;
    };

    # Create dirs for home-manager
    systemd.tmpfiles.rules = [
      "d /nix/var/nix/profiles/per-user/${username} 0755 ${username} root"
    ];
  };
}

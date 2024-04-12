{
  lib,
  pkgs,
  config,
  ...
}: let
  root-reset-src = builtins.readFile ../bin/scripts/rootReset.sh;
  root-diff = pkgs.writeShellApplication {
    name = "root-diff";
    runtimeInputs = [pkgs.btrfs-progs];
    text = builtins.readFile ../bin/scripts/rootDiff.sh;
  };
in {
  options = {
    core.ephemeral = {
      enable =
        lib.mkEnableOption "Enable ephemeral";
    };
  };
  config = lib.mkIf config.core.ephemeral.enable {
    environment.systemPackages = lib.mkBefore [root-diff];
    boot.initrd.systemd = {
      enable = lib.mkDefault true;
      services.rollback = {
        description = "Rollback BTRFS root subvolume to a pristine state";
        wantedBy = [
          "initrd.target"
        ];
        after = [
          # LUKS/TPM process
          "systemd-cryptsetup@enc.service"
        ];
        before = [
          "sysroot.mount"
        ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = root-reset-src;
      };

      services.persisted-files = {
        description = "Hard-link persisted files from /persist";
        wantedBy = [
          "initrd.target"
        ];
        after = [
          "sysroot.mount"
        ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /sysroot/etc/
          ln -snfT /persist/etc/machine-id /sysroot/etc/machine-id
        '';
      };
    };
  };
}

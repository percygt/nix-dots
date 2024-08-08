{
  lib,
  config,
  inputs,
  libx,
  ...
}:
let
  root_path = lib.concatMapStrings (x: "/" + x) config.modules.core.systemd.initrd.rootDeviceName;
  root_device = "${lib.concatStringsSep "-" config.modules.core.systemd.initrd.rootDeviceName}.device";
  wipeScript = # bash
    ''
      mkdir /btrfs_tmp
      mount ${root_path} /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }
      # deletes old_root sub-volume older than 15days
      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +15); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';
  phase1Systemd = config.modules.core.systemd.initrd.enable;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];
  options.modules.core.ephemeral = {
    enable = libx.enableDefault "ephemeral";
  };
  config = lib.mkIf config.modules.core.ephemeral.enable {
    boot.initrd = {
      supportedFilesystems = [ "btrfs" ];
      postDeviceCommands = lib.mkIf (!phase1Systemd) (lib.mkBefore wipeScript);
      systemd.services.restore-root = lib.mkIf phase1Systemd {
        description = "Rollback btrfs rootfs";
        wantedBy = [ "initrd.target" ];
        requires = [ root_device ];
        after = [ root_device ];
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = wipeScript;
      };
    };
    fileSystems."/persist".neededForBoot = true;
    environment.persistence = {
      "/persist/system" = {
        hideMounts = true;
        directories = [
          "/var/lib/systemd/coredump"
          "/var/lib/nixos"
          "/srv"
          {
            directory = "/var/lib/colord";
            user = "colord";
            group = "colord";
            mode = "u=rwx,g=rx,o=";
          }
        ];
        files = [ "/etc/machine-id" ];
      };
    };
  };
}

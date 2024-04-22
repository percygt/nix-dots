{lib, ...}: {
  environment.etc = {
    "crypttab".text = ''
      data  /dev/disk/by-partlabel/disk-home-data  /persist/system/keys/data.keyfile
    '';
  };

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            root = {
              name = "root";
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "root_vg";
              };
            };
          };
        };
      };

      home = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                type = "luks";
                name = "data";
                settings = {
                  allowDiscards = true;
                  keyFile = "/tmp/data.keyfile";
                };
                # Don't try to unlock this drive early in the boot.
                initrdUnlock = lib.mkForce false;
                content = {
                  type = "filesystem";
                  format = "btrfs";
                  mountpoint = "/home/percygt/data";
                  mountOptions = ["compress=lzo" "x-gvfs-show"];
                  extraArgs = ["-L" "data" "-f"];
                };
              };
            };
          };
        };
      };
    };

    #------------------------------------------------------------------------------
    lvm_vg = {
      root_vg = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "root" = {
                  mountpoint = "/";
                };
                "persist" = {
                  mountOptions = ["compress=lzo" "noatime"];
                  mountpoint = "/persist";
                };
                "nix" = {
                  mountOptions = ["compress=lzo" "noatime"];
                  mountpoint = "/nix";
                };
                "var/log" = {
                  mountOptions = ["compress=lzo" "noatime"];
                  mountpoint = "/var/log";
                };
              };
            };
          };
          windows = {
            size = "80G";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/home/percygt/windows";
              mountOptions = ["defaults"];
              extraArgs = ["-L" "windows" "-f"];
            };
          };
        };
      };
    };
  };

  fileSystems."/var/log".neededForBoot = true;
}

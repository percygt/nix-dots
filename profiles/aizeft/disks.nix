{disks ? ["/dev/nvme0n1" "/dev/sda"], ...}: {
  environment.etc = {
    "crypttab".text = ''
      data  /dev/disk/by-partlabel/data  /etc/secrets/data.keyfile
    '';
  };
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = builtins.elemAt disks 0;
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
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                mountpoint = "/";
                mountOptions = ["defaults"];
                extraArgs = ["-L" "nixos" "-f"];
                subvolumes = {
                  "home" = {
                    mountOptions = ["compress=lzo"];
                    mountpoint = "/home";
                  };
                  "nix" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/nix";
                  };
                  "var/cache" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/var/cache";
                  };
                  "var/tmp" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/var/tmp";
                  };
                  "var/log" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/var/log";
                  };
                };
              };
            };
            windows = {
              end = "-85000M";
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
      #------------------------------------------------------------------------------
      sda = {
        device = builtins.elemAt disks 1;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            data = {
              start = "0%";
              end = "100%";
              content = {
                type = "luks";
                name = "data";

                settings = {
                  keyFile = "/tmp/data.keyfile";
                  allowDiscards = true;
                };

                # Don't try to unlock this drive early in the boot.
                initrdUnlock = false;
                content = {
                  type = "filesystem";
                  format = "btrfs";
                  mountpoint = "/home/percygt/data";
                  mountOptions = ["compress=lzo" "x-gvfs-show"];
                  extraArgs = ["-L" "DATA" "-f"];
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/var/log".neededForBoot = true;
}

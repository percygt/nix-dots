{lib, ...}: {
  environment.etc = {
    "crypttab".text = ''
      data  /dev/disk/by-partlabel/disk-sda-data  /etc/nixos/keys/data.keyfile
    '';
  };

  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = "/dev/vda";
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
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-L" "nixos" "-f"];
                subvolumes = {
                  "root" = {
                    mountpoint = "/";
                  };
                  "home" = {
                    mountOptions = ["compress=lzo"];
                    mountpoint = "/home";
                  };
                  "nix" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/nix";
                  };
                  "keys" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/etc/nixos/keys";
                  };
                };
              };
            };
            windows = {
              size = "5G";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/home/percygt/windows";
                mountOptions = ["defaults"];
                extraArgs = ["-L" "windows" "-f"];
              };
            };
            data = {
              size = "5G";
              content = {
                type = "luks";
                name = "data";
                settings = {
                  allowDiscards = true;
                  keyFile = "/tmp/data.keyfile";
                };
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
  };
}

{lib, ...}: {
  environment.etc = {
    "crypttab".text = ''
      data  /dev/root_vg/data  /etc/nixos/keys/data.keyfile
    '';
  };

  disko.devices = {
    disk.main = {
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
              mountOptions = ["umask=0077" "shortname=winnt"];
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
    lvm_vg = {
      root_vg = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
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
                "persist" = {
                  mountOptions = ["compress=lzo" "noatime"];
                  mountpoint = "/persist";
                };

                "nix" = {
                  mountOptions = ["compress=lzo" "noatime"];
                  mountpoint = "/nix";
                };
              };
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
        };
      };
    };
  };
}

{
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
            windows = {
              size = "8500M";
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
  };
}

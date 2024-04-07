{lib, ...}: {
  environment.etc = {
    "crypttab".text = ''
      data  /dev/disk/by-partlabel/disk-sda-data  /etc/secrets/data.keyfile
    '';
  };

  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = lib.mkDefault "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountOptions = ["umask=0077" "shortname=winnt"];
                mountpoint = "/boot/efi";
              };
            };
            root = {
              size = "20G";
              content = {
                type = "btrfs";
                extraArgs = ["-L" "NIXOS" "-f"];
                mountpoint = "/";
                mountOptions = ["defaults"];
                subvolumes = {
                  "home" = {
                    mountOptions = ["compress=lzo"];
                    mountpoint = "/home";
                  };
                  "nix" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/nix";
                  };
                  "var/log" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/var/log";
                  };
                  "var/tmp" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/var/tmp";
                  };
                  "var/cache" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/var/cache";
                  };
                  "etc/secrets" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/etc/secrets";
                  };
                };
              };
            };
            data = {
              size = "100%";
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
                  extraArgs = ["-L" "DATA" "-f"];
                };
              };
            };
          };
        };
      };
    };
  };
}

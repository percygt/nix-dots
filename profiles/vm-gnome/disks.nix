{lib, ...}: {
  environment.etc = {
    "crypttab".text = ''
      data  /dev/disk/by-partlabel/disk-sda-data  /etc/secrets/vm-gnome-data.keyfile
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
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-L" "nixos" "-f"];
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
              size = "5G";
              content = {
                type = "luks";
                name = "data";
                settings = {
                  allowDiscards = true;
                  keyFile = "/tmp/vm-gnome-data.keyfile";
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

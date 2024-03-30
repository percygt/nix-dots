{
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "ESP";
              size = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
                mountOptions = [
                  "umask=0077"
                  "shortname=winnt"
                ];
              };
            };
            root = {
              # size = "205000M";
              size = "20500M";
              content = {
                type = "btrfs";
                mountpoint = "/";
                mountOptions = ["defaults"];
                extraArgs = ["-L" "NIXOS" "-f"];
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
              # size = "85000M";
              size = "8500M";
              content = {
                type = "filesystem";
                format = "btrfs";
                mountpoint = "/home/percygt/windows";
                mountOptions = ["compress=lzo" "x-gvfs-show"];
                extraArgs = ["-L" "WINDOWS" "-f"];
              };
            };
            data = {
              size = "100%";
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

  fileSystems."/var/log".neededForBoot = true;
}

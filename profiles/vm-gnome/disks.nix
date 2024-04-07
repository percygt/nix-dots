{
  disko.devices = {
    disk = {
      nvme = {
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
              size = "-8500M";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/home/percygt/windows";
                mountOptions = ["defaults"];
                extraArgs = ["-L" "WINDOWS" "-f"];
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/var/log".neededForBoot = true;
}

{lib, ...}: {
  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = lib.mkDefault "/dev/sda";
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
              };
            };
            root = {
              start = "1024M";
              end = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-L" "NIXOS" "-f"];
                mountpoint = "/";
                subvolumes = {
                  "root" = {
                    mountOptions = ["compress=lzo"];
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
                  "opt" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/opt";
                  };
                  "var/cache" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/var/cache";
                  };
                  "var/crash" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/var/crash";
                  };
                  "var/tmp" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/var/tmp";
                  };
                  "var/log" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/var/log";
                  };
                  "var/spool" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/var/spool";
                  };
                  "var/www" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/var/www";
                  };
                  "var/lib/gdm" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/var/lib/gdm";
                  };
                  "var/lib/AccountsService" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/var/lib/AccountsService";
                  };
                };
              };
            };
            # data = {
            #   start = "20G";
            #   end = "100%";
            #   content = {
            #     type = "btrfs";
            #     extraArgs = ["-L" "DATA" "-f"];
            #     mountpoint = "/data";
            #   };
            # };
          };
        };
      };
    };
  };

  fileSystems."/var/log".neededForBoot = true;
}

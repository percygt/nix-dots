{
  disko.devices = {
    disk = {
      
      sda = {
        type = "disk";
        device = "/dev/disk/by-label/NIXOS";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "UEFI";
              name = "ESP";
              size = "512M";
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
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-L" "NIXOS" "-f"];
                mountpoint = "/";
                subvolumes = {
                  "home" = {
                    mountOptions = ["compress=lzo"];
                    mountpoint = "/home";
                  };
                  "home/percygt/.var/app/com.brave.Browser" = {
                    mountOptions = ["compress=lzo"];
                    mountpoint = "/home/percygt/.var/app/com.brave.Browser";
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
                  "var/lib/libvirt/images" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/var/lib/libvirt/images";
                  };
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

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
              label = "UEFI";
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-L" "NIXOS" "-f"]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                  };
                  "/home" = {
                    mountOptions = ["compress=lzo" "subvol=home"];
                    mountpoint = "/home";
                  };
                  "/nix" = {
                    mountOptions = ["compress=lzo" "noatime" "subvol=nix"];
                    mountpoint = "/nix";
                  };
                  "/opt" = {
                    mountOptions = ["compress=lzo" "noatime" "subvol=opt"];
                    mountpoint = "/opt";
                  };
                  "/var/cache" = {
                    mountOptions = ["compress=lzo" "noatime" "subvol=var/cache"];
                    mountpoint = "/var/cache";
                  };
                  "/var/crash" = {
                    mountOptions = ["compress=lzo" "noatime" "subvol=var/crash"];
                    mountpoint = "/var/crash";
                  };
                  "/var/tmp" = {
                    mountOptions = ["compress=lzo" "noatime" "subvol=var/tmp"];
                    mountpoint = "/var/tmp";
                  };
                  "/var/log" = {
                    mountOptions = ["compress=lzo" "noatime" "subvol=var/log"];
                    mountpoint = "/var/log";
                  };
                  "/var/spool" = {
                    mountOptions = ["compress=lzo" "noatime" "subvol=var/spool"];
                    mountpoint = "/var/spool";
                  };
                  "/var/www" = {
                    mountOptions = ["compress=lzo" "noatime" "subvol=var/www"];
                    mountpoint = "/var/www";
                  };
                  "/var/lib/gdm" = {
                    mountOptions = ["compress=lzo" "noatime" "subvol=var/lib/gdm"];
                    mountpoint = "/var/lib/gdm";
                  };
                  "/var/lib/AccountsService" = {
                    mountOptions = ["compress=lzo" "noatime" "subvol=var/lib/AccountsService"];
                    mountpoint = "/var/lib/AccountsService";
                  };
                  "/var/lib/libvirt/images" = {
                    mountOptions = ["compress=lzo" "noatime" "subvol=var/lib/libvirt/images"];
                    mountpoint = "/var/lib/libvirt/images";
                  };
                  "/home/$USER/.var/app/com.brave.Browser" = {
                    mountOptions = ["compress=lzo" "subvol=home/$USER/.var/app/com.brave.Browser"];
                    mountpoint = "/home/$USER/.var/app/com.brave.Browser";
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

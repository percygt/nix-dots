{lib, ...}: {
  # environment.etc = {
  #   "crypttab".text = ''
  #     data  /dev/disk/by-partlabel/data  /etc/data.keyfile
  #   '';
  #};

  # boot.initrd.luks.devices.data = {
  #   device = lib.mkForce "/dev/disk/by-partlabel/data";
  #   allowDiscards = true;
  #   preLVM = true;
  # };

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
                  "var/lib/AccountsService" = {
                    mountOptions = ["compress=lzo" "noatime"];
                    mountpoint = "/var/lib/AccountsService";
                  };
                  ".snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = ["compress=lzo" "noatime"];
                  };
                };
              };
            };
            data = {
              size = "100%";
              # label = "luks";
              # content = {
              #   type = "luks";
              # extraFormatArgs = [
              #     "--iter-time 1" # insecure but fast for tests
              #   ];k
              #   settings = {
              #     allowDiscards = true;
              #     keyFile = "/tmp/data.keyfile";
              #   };
              #   initrdUnlock = false;
              # name = "data";
              content = {
                type = "filesystem";
                format = "btrfs";
                extraArgs = ["-f"];
                mountpoint = "/home/percygt/data";
                mountOptions = ["compress=lzo"];
              };
            };
            # };
          };
        };
      };
    };
  };
  fileSystems."/var/log".neededForBoot = true;
}

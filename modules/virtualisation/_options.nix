{ lib, ... }:
let
  inherit (lib)
    mkOption
    mkEnableOption
    types
    ;
in
{
  options.modules.virtualisation = {
    docker.enable = mkEnableOption "Enable docker";
    kvm.enable = mkEnableOption "Enable kvm";
    podman.enable = mkEnableOption "Enable podman";
    vmvariant.enable = mkEnableOption "Enable vmvariant";
    waydroid.enable = mkEnableOption "Enable waydroid";
    windows = {
      enable = mkEnableOption "Windows VM";
      domainName = mkOption {
        type = with types; uniq str;
        description = "The domain name for the virtual machine.";
        default = "windows";
      };

      uuid = mkOption {
        type = with types; uniq str;
        description = "The UUID for the virtual machine.";
      };

      cpu = {
        cores = mkOption {
          type = with types; uniq int;
          description = "The amount of cores.";
        };

        threads = mkOption {
          type = with types; uniq int;
          description = "The amount of threads per core.";
        };
      };

      memory = mkOption {
        type = with types; uniq int;
        description = "The amount of memory, in GiB.";
      };

      diskPath = mkOption {
        type = with types; uniq str;
        description = "The location of the disk image.";
      };

      nvramPath = mkOption {
        type = with types; uniq str;
        description = "The location of the NVRAM data.";
      };

      sysinfo = {
        bios = {
          vendor = mkOption {
            type = types.str;
            description = "BIOS vendor string.";
          };
          version = mkOption {
            type = types.str;
            description = "BIOS version string.";
          };
          date = mkOption {
            type = types.str;
            description = "BIOS release date (MM/DD/YYYY).";
          };
        };

        system = {
          manufacturer = mkOption {
            type = types.str;
            description = "System manufacturer.";
          };
          product = mkOption {
            type = types.str;
            description = "System product/model.";
          };
          version = mkOption {
            type = types.str;
            description = "System version string.";
          };
          serial = mkOption {
            type = types.str;
            description = "System serial number.";
          };
          family = mkOption {
            type = types.str;
            description = "System family.";
          };
        };
      };

      pciDevices = mkOption {
        type = types.listOf types.attrs;
        default = [ ];
        description = "A list of PCI devices to passthrough to the guest.";
      };
    };

  };
}

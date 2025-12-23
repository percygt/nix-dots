{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.virtualisation.windows;
in
{
  config = mkIf cfg.enable {
    virtualisation.libvirt.connections."qemu:///session".domains = [
      {
        active = false;
        definition = pkgs.replaceVars ./windows.xml {
          uuid = cfg.uuid;

          domainName = cfg.domainName;
          memory = cfg.memory;
          vcpu = cfg.cpu.cores * cfg.cpu.threads;
          loaderPath = "${pkgs.qemu}/share/qemu/edk2-x86_64-secure-code.fd";
          nvramTemplate = "${pkgs.qemu}/share/qemu/edk2-i386-vars.fd";
          nvramPath = cfg.nvramPath;

          biosVendor = cfg.sysinfo.bios.vendor;
          biosVersion = cfg.sysinfo.bios.version;
          biosDate = cfg.sysinfo.bios.date;

          systemManufacturer = cfg.sysinfo.system.manufacturer;
          systemProduct = cfg.sysinfo.system.product;
          systemVersion = cfg.sysinfo.system.version;
          systemSerial = cfg.sysinfo.system.serial;
          systemFamily = cfg.sysinfo.system.family;

          cores = cfg.cpu.cores;
          threads = cfg.cpu.threads;

          qemuPath = "${pkgs.qemu}/bin/qemu-system-x86_64";

          diskPath = cfg.diskPath;
          pciDevices = lib.concatStringsSep "\n" (
            map (pciDevice: ''
              <hostdev mode="subsystem" type="pci" managed="yes">
                <source>
                  <address domain="${pciDevice.source.domain}" bus="${pciDevice.source.bus}" slot="${pciDevice.source.slot}" function="${pciDevice.source.function}"/>
                </source>
              </hostdev>
            '') cfg.pciDevices
          );
        };
      }
    ];
  };
}

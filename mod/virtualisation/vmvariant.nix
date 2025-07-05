{ lib, config, ... }:
let
  g = config._base;
in
{
  config = lib.mkIf config.modules.virtualisation.vmvariant.enable {
    virtualisation.vmVariant = {
      virtualisation = {
        # following configuration is added only when building VM with build-vm
        qemu.options = [
          # Better display option
          "-vga virtio"
          "-display gtk"
          # Enable copy/paste
          # https://www.kraxel.org/blog/2021/05/qemu-cut-paste/
          "-chardev qemu-vdagent,id=ch1,name=vdagent,clipboard=on"
          "-device virtio-serial-pci"
          "-device virtserialport,chardev=ch1,id=ch1,name=com.redhat.spice.0"
        ];
        sharedDirectories = {
          sharedData = {
            source = "${g.dataDirectory}/vms/shared";
            target = "/mnt/shared";
          };
        };
        memorySize = 8192; # Use 2048MiB memory.
        cores = 4;
      };
    };
  };
}

{pkgs, ...}: {
  boot = {
    initrd = {
      availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk"];
      kernelModules = [];
    };

    extraModulePackages = [];
    kernelModules = ["kvm-intel"];

    # Use the latest Linux kernel, rather than the default LTS
    kernelPackages = pkgs.linuxPackages_latest;
  };
}

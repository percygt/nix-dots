{
  inputs,
  ...
}:
{
  imports = [
    ./disks.nix
    inputs.disko.nixosModules.disko
  ];

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
  };

  boot = {
    initrd.availableKernelModules = [
      "ahci"
      "xhci_pci"
      "virtio_pci"
      "sr_mod"
      "virtio_blk"
    ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

}

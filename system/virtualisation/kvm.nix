{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    libguestfs
    win-virtio
    win-spice
    spice
    spice-gtk
    spice-protocol
    virt-viewer
    virtiofsd
    qemu
    kmod
    pciutils
  ];
  programs.dconf.enable = true;
  programs.virt-manager.enable = true;

  boot.kernelParams = ["intel_iommu=on" "iommu=pt"];

  users.users.${username}.extraGroups = ["libvirtd" "kvm"];
  services.spice-vdagentd.enable = true;
  virtualisation = {
    kvmgt.enable = true;
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      allowedBridges = [
        "br0"
      ];
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [pkgs.OVMFFull.fd];
        };
      };
    };
  };
}

{
  pkgs,
  username,
  ...
}: let
  bridgeName = "br0";
in {
  environment.systemPackages = with pkgs; [
    gnome.adwaita-icon-theme
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
    quickemu
    pciutils
    (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
      qemu-system-x86_64 \
        -bios ${pkgs.OVMFFull.fd}/FV/OVMF_CODE.fd \
        "$@"
    '')
  ];
  programs.dconf.enable = true;

  programs.virt-manager.enable = true;

  boot.kernelParams = ["intel_iommu=on" "iommu=pt"];
  users = {
    users.${username}.extraGroups = ["libvirtd" "qemu" "kvm"];
    groups.qemu = {};
  };
  services.spice-vdagentd.enable = true;
  virtualisation = {
    kvmgt.enable = true;
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      allowedBridges = [
        bridgeName
      ];
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        # package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [pkgs.OVMFFull.fd];
        };
      };
    };
  };
}

{
  pkgs,
  username,
  lib,
  config,
  ...
}: {
  options.virtual.kvm.enable = lib.mkEnableOption "Enable kvm";
  config = lib.mkIf config.virtual.kvm.enable {
    environment.systemPackages = with pkgs; [
      gnome.adwaita-icon-theme
      win-virtio
      win-spice
      spice
      spice-gtk
      spice-protocol
      virtiofsd
      qemu
      kmod
      quickemu
      pciutils
    ];

    programs.virt-manager.enable = true;

    boot.kernelParams = ["intel_iommu=on" "iommu=pt"];
    users = {
      users.${username}.extraGroups = ["qemu" "kvm"];
      groups.qemu = {};
    };
    # services.spice-vdagentd.enable = true;
    virtualisation = {
      spiceUSBRedirection.enable = true;
    };
  };
}

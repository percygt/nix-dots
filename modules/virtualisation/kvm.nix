{
  pkgs,
  lib,
  config,
  username,
  ...
}:
{
  config = lib.mkIf config.modules.virtualisation.kvm.enable {
    environment.systemPackages = with pkgs; [
      nixos-shell
      adwaita-icon-theme
      virtio-win # win-virtio
      win-spice
      spice
      spice-gtk
      spice-protocol
      virtiofsd
      qemu
      kmod
      pciutils
      quickemu
      quickgui
    ];

    programs.virt-manager.enable = true;

    boot.kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
    ];

    virtualisation.libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [
        virtiofsd
      ];
    };
    users = {
      users.${username}.extraGroups = [
        "libvirtd"
        "qemu"
        "kvm"
      ];
      groups = {
        qemu = { };
        libvirtd.members = [ username ];
      };
    };
  };
}

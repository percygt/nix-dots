{
  pkgs,
  lib,
  config,
  username,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixvirt.nixosModules.default
  ];
  config = lib.mkIf config.modules.virtualisation.kvm.enable {
    persistSystem.directories = [ "/var/lib/libvirt" ];
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
    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        qemu.vhostUserPackages = with pkgs; [
          virtiofsd
        ];
      };
    };
    users = {
      users.${username}.extraGroups = [
        "input"
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

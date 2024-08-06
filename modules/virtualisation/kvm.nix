{
  pkgs,
  lib,
  config,
  ...
}:
let
  g = config._general;
in
{
  options.modules.virtualisation.kvm.enable = lib.mkEnableOption "Enable kvm";
  config = lib.mkIf config.modules.virtualisation.kvm.enable {
    environment.systemPackages = with pkgs; [
      adwaita-icon-theme
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

    boot.kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
    ];
    users = {
      users.${g.username}.extraGroups = [
        "qemu"
        "kvm"
      ];
      groups.qemu = { };
    };
    # services.spice-vdagentd.enable = true;
    virtualisation = {
      spiceUSBRedirection.enable = true;
      # libvirtd = {
      #   enable = true;
      #   qemu = {
      #     swtpm.enable = true;
      #     ovmf.enable = true;
      #     ovmf.packages = [ pkgs.OVMFFull.fd ];
      #   };
      # };
    };
  };
}

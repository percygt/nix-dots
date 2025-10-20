{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    common-gpu-nvidia-disable
  ];
  hardware = {
    intelgpu = {
      driver = "xe";
      vaapiDriver = "intel-media-driver";
      # enableHybridCodec = true;
    };
  };
  environment.systemPackages = with pkgs; [
    vulkan-tools
    vdpauinfo
    glxinfo
    intel-gpu-tools
    libva-utils
  ];
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    VDPAU_DRIVER = "va_gl";
    ANV_DEBUG = "video-decode,video-encode";
  };
  services.xserver.videoDrivers = lib.mkDefault [ "intel" ];
  # boot.kernelParams = [
  #   "i915.enable_guc=3"
  #   "i915.force_probe=9a49"
  # ];
  boot.kernelParams = [
    "i915.force_probe=!9a49"
    "xe.force_probe=9a49"
  ];
  services.thermald.enable = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "vmd"
      "ahci"
      "nvme"
      "usb_storage"
      "usbhid"
      "uas"
      "sd_mod"
      "rtsx_usb_sdmmc"
    ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };
  # services.asusd.enable = true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

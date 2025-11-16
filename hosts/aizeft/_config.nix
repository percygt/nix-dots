{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-gpu-nvidia-disable
  ];
  services.xserver.videoDrivers = lib.mkDefault [ "intel" ];
  # boot.kernelParams = [
  #   "i915.enable_guc=3"
  #   "i915.force_probe=9a49"
  # ];
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
    initrd.kernelModules = [ "xe" ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    kernelParams = [
      "i915.force_probe=!9a49"
      "xe.force_probe=9a49"
    ];
  };
  hardware = {
    graphics = with pkgs.my; {
      package = mesa;
      package32 = mesa-32;
      extraPackages = [
        intel-vaapi-driver
        intel-media-driver
        intel-compute-runtime
        vpl-gpu-rt
        intel-ocl
      ];
      extraPackages32 = [
        intel-vaapi-driver-32
        intel-media-driver-32
      ];
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
    # VDPAU_DRIVER = "va_gl";
    # ANV_DEBUG = "video-decode,video-encode";
  };
  services.thermald.enable = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # services.asusd.enable = true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

{ lib, inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disks.nix
  ];

  modules = {
    driver = {
      adb.enable = true;
      bluetooth.enable = true;
      intel.enable = true;
      printer.enable = true;
    };
    dev.enable = true;
    cli.enable = true;
    editor = {
      neovim.enable = true;
      emacs.enable = true;
      # vscode.enable = true;
    };
    networking = {
      vpn.enable = true;
      tailscale.enable = true;
      syncthing.enable = true;
    };
    # pentesting = {
    #   wireless.enable = true;
    #   proxies.enable = true;
    #   traffic.enable = true;
    # };
    # virtualisation = {
    #   docker.enable = true;
    #   podman.enable = true;
    #   kvm.enable = true;
    #   vmvariant.enable = true;
    # };
  };

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "vmd"
      "ahci"
      "usb_storage"
      "usbhid"
      "uas"
      "sd_mod"
      "rtsx_usb_sdmmc"
    ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

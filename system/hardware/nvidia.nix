{config, ...}: {
  services.xserver.videoDrivers = ["nvidia"];

  programs.hyprland = {
    nvidiaPatches = true;
  };

  hardware.nvidia = {
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    modesetting.enable = true;

    powerManagement = {
      enable = true;
      finegrained = true;
    };

    open = true;
    nvidiaSettings = false; # gui app
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
}

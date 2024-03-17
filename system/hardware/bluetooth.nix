{pkgs, ...}: {
  # bluetooth
  hardware.bluetooth = {
    package = pkgs.bluez;
    enable = true;
    settings = {
      General = {
        Experimental = true;
        KernelExperimental = true;
      };
    };
  };
  # services.blueman.enable = true;
  environment.systemPackages = with pkgs; [ blueberry ];
}

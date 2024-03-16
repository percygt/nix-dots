{
  lib,
  pkgs,
  ...
}: {
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
  };

  services.udev.extraRules = ''
    KERNEL=="rtc0", GROUP="audio"
    KERNEL=="hpet", GROUP="audio"
  '';

  environment.etc = {
    "pipewire/pipewire.conf.d/92-low-latency.conf".text = ''
      context.properties = {
        default.clock.rate = 44100
        default.clock.quantum = 512
        default.clock.min-quantum = 512
        default.clock.max-quantum = 512
      }
    '';
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
  hardware.pulseaudio.enable = lib.mkForce false;
}

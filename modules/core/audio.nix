{
  lib,
  pkgs,
  config,
  desktop,
  username,
  ...
}:
{
  config = lib.mkIf config.modules.core.audio.enable {
    persistHome.directories = [ ".local/state/wireplumber" ];
    environment.systemPackages = lib.mkIf (desktop != null) (
      with pkgs;
      [
        pavucontrol
        pwvucontrol
      ]
    );
    boot.kernelParams = [ "threadirqs" ];

    # $username is you, whoever you are
    users.users.${username}.extraGroups = [
      "audio"
      "rtkit"
    ];
    # allow members of "audio" to set RT priorities up to 90
    security.pam.loginLimits = [
      {
        domain = "@audio";
        type = "-";
        item = "rtprio";
        value = "90";
      }
    ];
    # expose important timers etc. to "audio"
    services.udev.extraRules = ''
      DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
      DEVPATH=="/devices/virtual/misc/hpet", OWNER="root", GROUP="audio", MODE="0660"
    '';

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/99-alsa-config.conf" ''
          monitor.alsa.rules = [
            {
              matches = [
                {
                  node.name = "~alsa_output.*"
                }
              ]
              actions = {
                update-props = {
                  api.alsa.headroom = 1024
                }
              }
            }
          ]
        '')
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-disable-suspension.conf" ''
          monitor.alsa.rules = [
            {
              matches = [
                {
                  node.name = "~alsa_input.*"
                }
                {
                  node.name = "~alsa_output.*"
                }
              ]
              actions = {
                update-props = {
                  session.suspend-timeout-seconds = 0
                }
              }
            }
          ]
        '')
      ];
    };
  };
}

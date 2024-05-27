{
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  options = {
    core.audioengine = {
      enable =
        lib.mkEnableOption "Enable audioengine services";
    };
  };

  config = lib.mkIf config.core.audioengine.enable {
    environment.persistence = {
      "/persist".users.${username}.directories = [
        ".local/state/wireplumber"
      ];
    };
    sound.enable = true;
    hardware.pulseaudio.enable = lib.mkForce false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;

      wireplumber.configPackages = [
        (
          pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-disable-suspension.conf"
          ''
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
          ''
        )
        (
          pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/50-bluez.conf"
          ''
            monitor.bluez.rules = [
              {
                matches = [
                  {
                    ## This matches all bluetooth devices.
                    device.name = "~bluez_card.*"
                  }
                ]
                actions = {
                  update-props = {
                    bluez5.auto-connect = [ a2dp_sink  a2dp_source ]
                    bluez5.hw-volume = [ a2dp_sink a2dp_source ]
                  }
                }
              }
            ]

            monitor.bluez.properties = {
              bluez5.headset-roles = [ ]
              bluez5.hfphsp-backend = "none"
            }
          ''
        )
      ];
    };

    environment.systemPackages = with pkgs; [
      pavucontrol
    ];
  };
}

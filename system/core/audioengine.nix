{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    core.audioengine = {
      enable =
        lib.mkEnableOption "Enable audioengine services";
    };
  };

  config = lib.mkIf config.core.audioengine.enable {
    programs.noisetorch.enable = true;
    hardware.pulseaudio.enable = lib.mkForce false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;

      wireplumber.configPackages = [
        (pkgs.writeTextDir "share/wireplumber/main.lua.d/51-disable-suspension.lua" ''
          table.insert (alsa_monitor.rules, {
            matches = {
              {
                { "node.name", "matches", "*Audioengine*" },
              },
            },
            apply_properties = {
              ["session.suspend-timeout-seconds"] = 0,
            },
          })
        '')
      ];
    };

    environment.systemPackages = with pkgs; [
      pavucontrol
    ];
  };
}

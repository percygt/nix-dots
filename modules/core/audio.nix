{
  lib,
  pkgs,
  config,
  desktop,
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
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.configPackages = [
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

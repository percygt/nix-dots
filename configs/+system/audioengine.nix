{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [ pavucontrol ];
  modules.core.persist.userData.directories = [ ".local/state/wireplumber" ];
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/52-alsa-rename.conf" ''
        monitor.alsa.rules = [
          {
            matches = [
              {
                node.name = "~alsa_output.*"
              }
            ]
            actions = {
              update-props = {
                node.nick = "󰓃"
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
}

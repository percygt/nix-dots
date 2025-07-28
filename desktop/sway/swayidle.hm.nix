{
  pkgs,
  config,
  lib,
  ...
}:
let
  g = config._base;
  cfg = config.modules.desktop.sway;
  swaymsg = "${cfg.finalPackage}/bin/swaymsg";
in
{
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "after-resume";
        command = lib.getExe (
          pkgs.writeShellApplication {
            name = "swayidle-after-resume";
            runtimeInputs = g.system.envPackages ++ [
              pkgs.pomo
              cfg.finalPackage
            ];
            text = ''
              if [ -f "$HOME/.local/share/pomo" ]; then pomo start || true; fi
              ${swaymsg} 'reload'
            '';
          }
        );
      }
    ];
    timeouts = [
      {
        timeout = 30 * 60;
        command = "${swaymsg} 'output * power off'";
        resumeCommand = "${swaymsg} 'output * power on'";
      }
    ];
  };
}

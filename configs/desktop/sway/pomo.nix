## source: https://github.com/stelcodes/nixos-config/blob/dfdbd1fab39f55c32875366e6467d056cf619cfd/modules/sway/+home.nix#L1055
{
  pkgs,
  config,
  lib,
  ...
}:
let
  g = config._base;
in
{
  home.packages = [ pkgs.pomo ];
  systemd.user.services = {
    pomo-notify = {
      Unit = {
        Description = "pomo.sh notify daemon";
      };
      Service = {
        Type = "simple";
        Environment = "PATH=$PATH:${
          lib.makeBinPath (
            g.system.envPackages
            ++ [
              pkgs.pomo
              g.desktop.sway.finalPackage
              config.programs.swaylock.package
            ]
          )
        }";
        ExecStart = "${pkgs.pomo}/bin/pomo notify";
        Restart = "always";
      };
      Install.WantedBy = [ "sway-session.target" ];
    };
  };
  xdg.configFile."pomo.cfg" = {
    onChange = ''
      ${pkgs.systemd}/bin/systemctl --user restart pomo-notify.service
    '';
    source = pkgs.writeShellScript "pomo-cfg" ''
      # This file gets sourced by pomo.sh at startup
      function lock_screen {
        if ${pkgs.procps}/bin/pgrep sway 2>&1 > /dev/null; then
          echo "Sway detected"
          # Only lock if pomo is still running
          test -f $HOME/.local/share/pomo && ${config.programs.swaylock.package}/bin/swaylock
          # Only restart pomo if pomo is still running
          test -f $HOME/.local/share/pomo && ${pkgs.pomo}/bin/pomo start
        fi
      }

      function custom_notify {
          # send_msg is defined in the pomo.sh source
          block_type=$1
          if [[ $block_type -eq 0 ]]; then
              echo "End of work period"
              notify-send -i kronometer 'Pomodoro' 'End of a work period. Locking Screen!'
              ${pkgs.playerctl}/bin/playerctl --all-players pause
              lock_screen &
          elif [[ $block_type -eq 1 ]]; then
              echo "End of break period"
              notify-send -i kronometer 'Pomodoro' 'End of a break period. Time for work!'
          else
              echo "Unknown block type"
              exit 1
          fi
      }
      POMO_MSG_CALLBACK="custom_notify"
      POMO_WORK_TIME=1
      POMO_BREAK_TIME=1
    '';
  };
}

{ pkgs, config, ... }:
let
  g = config._general;
  launchTmux = pkgs.writers.writeBash "launchTmux" ''
    if [ -d ${g.flakeDirectory} ]; then
      tmux has-session -t nix-dots 2>/dev/null
      if [ $? != 0 ]; then
        tmux new-session -ds nix-dots -c "${g.flakeDirectory}"
      fi
      tmux new-session -As nix-dots
    else
      tmux has-session -t home 2>/dev/null
      if [ $? != 0 ]; then
        tmux new-session -ds home -c "${g.homeDirectory}"
      fi
      tmux new-session -As home
    fi
  '';
in
{
  xdg.configFile."i3-quickterm/config.json".text =
    # json
    ''
      {
          "menu": "rofi -dmenu -p 'quickterm: ' -no-custom -auto-select",
          "term": "footclient --server-socket=/run/user/%U/foot-server.sock",
          "history": "{$HOME}/.cache/i3-quickterm/shells.order",
          "ratio": 1,
          "pos": "top",
          "shells": {
              "js": "node",
              "python": "ipython3 --no-banner",
              "shell": "{$SHELL}",
              "tmux": "${launchTmux}"
          }
      }
    '';
}

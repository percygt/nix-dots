{ config, ... }:
let
  g = config._global;
in
{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      export STARSHIP_CONFIG="${g.xdg.configHome}/starship.toml"
    '';
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:
{

  config = lib.mkIf config.modules.terminal.waveterm.enable {
    home.packages = [ pkgs.waveterm ];
  };
}

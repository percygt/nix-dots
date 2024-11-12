{ lib, ... }:
{
  options.modules.terminal = {
    tilix.enable = lib.mkEnableOption "Enable tilix";
    waveterm.enable = lib.mkEnableOption "Enable waveterm";
    xfce4-terminal.enable = lib.mkEnableOption "Enable xfce4-terminal";
  };
}

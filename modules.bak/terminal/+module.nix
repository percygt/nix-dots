{ lib, ... }:
{
  options.modules.terminal = {
    tilix.enable = lib.mkEnableOption "Enable tilix";
    xfce4-terminal.enable = lib.mkEnableOption "Enable xfce4-terminal";
    wezterm.enable = lib.mkEnableOption "Enable wezterm";
  };
}

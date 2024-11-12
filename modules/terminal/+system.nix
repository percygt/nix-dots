{ lib, config, ... }:
{
  config = lib.mkIf config.modules.terminal.xfce4-terminal.enable {
    programs.xfconf.enable = true;
  };
}

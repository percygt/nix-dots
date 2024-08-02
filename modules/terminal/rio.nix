{ lib, config, ... }:
{
  options.modules.terminal.rio.enable = lib.mkEnableOption "Enable rio";

  config = lib.mkIf config.modules.terminal.rio.enable {
    programs.rio = {
      enable = true;
    };
  };
}

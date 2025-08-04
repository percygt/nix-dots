{
  lib,
  config,
  ...
}:
let
  f = config.modules.fonts.shell;
  t = config.modules.themes;
  c = t.colors;
  g = config._base;
  cfg = config.modules.terminal.ghostty;
in
{
  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
    };
  };
}

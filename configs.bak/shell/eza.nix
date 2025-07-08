{ config, ... }:
let
  g = config._base;
  defaultShell = g.shell.default.package;
in
{
  programs.eza = {
    enable = defaultShell != g.shell.nushell.package;
    icons = "auto";
  };
}

{
  pkgs,
  config,
  lib,
  ...
}:
let
  termVar = "TERM=foot";
  termInfoVar = "TERMINFO=${config.modules.terminal.foot.package.terminfo}/share/terminfo";
  inherit (config.modules.editor) emacs;
in
{
  wayland.windowManager.sway.config.startup = [
    {
      command = lib.concatStringsSep " " [
        termVar
        termInfoVar
        "${emacs.finalPackage}/bin/emacs --fg-daemon"
      ];
      always = true;
    }
    {
      command = "foot --server";
      always = true;
    }
    { command = lib.getExe pkgs.autotiling; }
    {
      command = "tmux start-server";
      always = true;
    }
  ];
}

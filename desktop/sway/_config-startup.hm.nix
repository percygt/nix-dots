{ pkgs, lib, ... }:
{
  wayland.windowManager.sway.config.startup = [
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

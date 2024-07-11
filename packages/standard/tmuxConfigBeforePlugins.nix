{
  lib,
  tmuxPlugins,
  writeText,
}:
tmuxPlugins.mkTmuxPlugin {
  pluginName = "tmux-config-before-plugins";
  version = "xxx";
  rtpFilePath = "config-before-plugins.tmux";
  src = writeText "config-before-plugins.tmux" ''#!/usr/bin/env bash'';
  meta = with lib; {
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

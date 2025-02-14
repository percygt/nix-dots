{
  pkgs,
  lib,
  config,
  ...
}:
let
  viewRebuildLogCmd = pkgs.writers.writeBash "viewrebuildlogcommand" ''
    footclient --title=NixosRebuild --app-id=system-software-update -- journalctl -efo cat -u nixos-rebuild.service
  '';
in
{
  wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
    "Ctrl+KP_Insert" =
      "exec ddapp -t 'system-software-update' -m false -h 90 -w 90 -- ${viewRebuildLogCmd}";
    "Ctrl+Shift+KP_Insert" = "exec systemctl start nixos-rebuild";
    "Alt+Shift+KP_Insert" =
      lib.mkIf config.modules.core.autoupgrade.enable "exec systemctl stop nixos-upgrade";
  };
}

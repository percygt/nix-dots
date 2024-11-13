{
  lib,
  config,
  desktop,
  ...
}:
{
  config = lib.mkMerge [
    (lib.mkIf (config.modules.terminal.xfce4-terminal.enable && desktop != "xfce") {
      programs.xfconf.enable = true;
      modules.core.persist.userData.directories = [
        ".config/xfce4/xfconf"
      ];
    })
  ];
}

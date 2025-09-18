{
  lib,
  config,
  desktop,
  ...
}:
let
  g = config._global;
in
{
  config = lib.mkMerge [
    {
      environment.systemPackages = [ g.terminal.defaultPackage ];
    }
    (lib.mkIf (config.modules.terminal.xfce4-terminal.enable && desktop != "xfce") {
      programs.xfconf.enable = true;
      modules.fileSystem.persist.userData.directories = [
        ".config/xfce4/xfconf"
      ];
    })
  ];
}

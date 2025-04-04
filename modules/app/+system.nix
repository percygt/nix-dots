{
  lib,
  config,
  ...
}:
{
  config = lib.mkMerge [
    (lib.mkIf config.modules.app.zen.enable {
      modules.core.persist.userData.directories = [ ".zen" ];
    })
  ];
}

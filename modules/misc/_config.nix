{
  lib,
  config,
  ...
}:
{
  config = lib.mkMerge [
    (lib.mkIf config.modules.misc.atuin.enable {
      persistHome.directories = [
        ".local/share/atuin"
      ];
    })
    (lib.mkIf config.modules.misc.aria.enable {
      persistHome.directories = [
        ".local/share/aria2"
      ];
    })
  ];
}

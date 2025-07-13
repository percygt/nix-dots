{
  lib,
  config,
  ...
}:
{
  imports = [
    ./ollama.sys.nix
  ];
  config = lib.mkMerge [
    (lib.mkIf config.modules.misc.atuin.enable {
      modules.fileSystem.persist.userData.directories = [
        ".local/share/atuin"
      ];
    })
    (lib.mkIf config.modules.misc.aria.enable {
      modules.fileSystem.persist.userData.directories = [
        ".local/share/aria2"
      ];
    })
  ];
}

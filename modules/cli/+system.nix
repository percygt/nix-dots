{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.cli.enable {
    modules.fileSystem.persist.userData.directories = [
      ".local/share/atuin"
      ".local/share/aria2"
    ];
  };
}

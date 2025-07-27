{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.editor.zed.enable {
    modules.fileSystem.persist.userData.directories = [
      ".local/share/zed"
    ];
  };
}

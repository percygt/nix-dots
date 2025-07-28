{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.editor.helix.enable {
    modules.fileSystem.persist.userData.directories = [
      ".local/share/helix"
    ];
  };
}

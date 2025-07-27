{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.editor.emacs.enable {
    modules.fileSystem.persist.userData.directories = [
      ".local/share/doom"
    ];
  };
}

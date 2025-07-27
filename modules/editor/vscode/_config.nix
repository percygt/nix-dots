{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.editor.vscode.enable {
    modules.fileSystem.persist.userData.directories = [
      ".vscode"
    ];
  };
}

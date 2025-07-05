{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.editor.vscode.enable {
    modules.core.persist.userData.directories = [
      ".vscode"
    ];
  };
}

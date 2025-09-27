{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.editor.vscode.enable {
    persistHome.directories = [
      ".vscode"
    ];
  };
}

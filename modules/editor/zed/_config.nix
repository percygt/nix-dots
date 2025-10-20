{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.editor.zed.enable {
    persistHome.directories = [
      ".local/share/zed"
    ];
  };
}

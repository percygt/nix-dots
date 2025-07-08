{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.editor.zed.enable {
    modules.core.persist.userData.directories = [
      ".local/share/zed"
    ];
  };
}

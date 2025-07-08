{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.editor.helix.enable {
    modules.core.persist.userData.directories = [
      ".local/share/helix"
    ];
  };
}

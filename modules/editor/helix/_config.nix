{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.editor.helix.enable {
    persistHome.directories = [
      ".local/share/helix"
    ];
  };
}

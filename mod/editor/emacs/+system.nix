{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.editor.emacs.enable {
    modules.core.persist.userData.directories = [
      ".local/share/doom"
    ];
  };
}

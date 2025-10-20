{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.editor.emacs.enable {
    persistHome.directories = [
      ".local/share/doom"
    ];
  };
}

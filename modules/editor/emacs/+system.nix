{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.editor.emacs;
in
{
  config = lib.mkIf config.modules.editor.emacs.enable {
    environment.systemPackages = [ cfg.finalPackage ];
    modules.core.persist.userData.directories = [
      ".local/share/doom"
    ];
  };
}

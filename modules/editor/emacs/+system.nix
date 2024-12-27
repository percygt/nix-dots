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
    services.emacs = {
      enable = true;
      package = cfg.finalPackage;
      startWithGraphical = true;
    };
    modules.core.persist.userData.directories = [
      ".local/share/doom"
    ];
  };
}

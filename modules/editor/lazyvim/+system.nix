{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.editor.lazyvim;
in
{
  config = lib.mkIf cfg.enable {
    modules.core.persist.userData = {
      directories = [
        ".local/share/nvim"
        ".local/cache/nvim"
        ".local/state/nvim"
      ];
    };
  };
}

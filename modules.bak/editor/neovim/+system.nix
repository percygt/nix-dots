{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.editor.neovim;
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

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
        ".local/share/nvim/lazy"
        ".local/share/nvim/harpoon"
        ".local/share/nvim/sessions"
        ".local/share/nvim/org-roam.nvim"
        ".local/share/nvim/undodir"
        ".local/share/nvim/mason"
        ".local/cache/nvim"
        ".local/state/nvim"
      ];
      files = [ ".local/share/nvim/telescope_history" ];
    };
  };
}

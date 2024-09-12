{ lib, config, ... }:
let
  g = config._general;
  cfg = config.modules.editor.neovim;
in
{
  imports = [ ./module.nix ];
  config = lib.mkIf cfg.enable {
    # environment.systemPackages = [ cfg.package ];
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${g.username} = {
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
    };
    home-manager.users.${g.username} = {
      imports = [ ./home.nix ];
      modules.editor.neovim.enable = lib.mkDefault true;
    };
  };
}

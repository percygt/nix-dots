{
  lib,
  config,
  pkgs,
  ...
}:
let
  g = config._general;
in
{
  options.modules.editor.neovim.enable = lib.mkEnableOption "Enable modules.editor.neovimwide";
  config = lib.mkIf config.modules.editor.neovim.enable {
    environment.systemPackages = with pkgs; [ neovim-unstable ];
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${g.username} = {
          directories = [
            ".local/share/nvim/lazy"
            ".local/share/nvim/harpoon"
            ".local/share/nvim/sessions"
            ".local/share/nvim/undodir"
            ".local/share/nvim"
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

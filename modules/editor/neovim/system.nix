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
    environment.systemPackages = with pkgs; [ neovim ];
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${g.username} = {
          directories = [
            ".local/share/nvim"
            ".local/cache/nvim"
            ".local/state/nvim"
          ];
        };
      };
    };
    home-manager.users.${g.username} = {
      imports = [ ./home.nix ];
      modules.editor.neovim.enable = lib.mkDefault true;
    };
  };
}

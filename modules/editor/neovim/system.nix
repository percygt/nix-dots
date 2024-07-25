{
  username,
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.editor.neovim.enable = lib.mkEnableOption "Enable modules.editor.neovimwide";
  config = lib.mkIf config.modules.editor.neovim.enable {
    environment.systemPackages = with pkgs; [ neovim ];
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
      "/persist" = {
        users.${username} = {
          directories = [
            ".local/share/nvim"
            ".local/cache/nvim"
            ".local/state/nvim"
          ];
        };
      };
    };
    home-manager.users.${username} = {
      imports = [ ./home.nix ];
      modules.editor.neovim.enable = lib.mkDefault true;
    };
  };
}

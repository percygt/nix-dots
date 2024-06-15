{
  username,
  lib,
  config,
  pkgs,
  ...
}: {
  options.editor = {
    neovim.system.enable = lib.mkEnableOption "Enable neovim systemwide";
    neovim.persist.enable = lib.mkOption {
      description = "Enable neovim persist";
      default = config.core.ephemeral.enable;
      type = lib.types.bool;
    };
  };
  config = lib.mkIf config.editor.neovim.system.enable {
    environment.systemPackages = with pkgs; [neovim];
    environment.persistence = lib.mkIf config.editor.neovim.persist.enable {
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
      imports = [./home.nix];
      editor.neovim.home.enable = lib.mkDefault true;
    };
  };
}

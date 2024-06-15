{
  username,
  lib,
  config,
  pkgs,
  ...
}: {
  options.editor = {
    emacs.system.enable = lib.mkEnableOption "Enable emacs systemwide";
    emacs.persist.enable = lib.mkOption {
      description = "Enable emacs persist";
      default = config.core.ephemeral.enable;
      type = lib.types.bool;
    };
  };
  config = lib.mkIf config.editor.neovim.system.enable {
    environment.systemPackages = with pkgs; [emacs-unstable-pgtk];
    environment.persistence = lib.mkIf config.editor.neovim.persist.enable {
      "/persist" = {
        users.${username} = {
          directories = [
            ".config/emacs"
          ];
        };
      };
    };
    home-manager.users.${username} = {
      imports = [./home.nix];
      editor.emacs.home.enable = lib.mkDefault true;
    };
  };
}

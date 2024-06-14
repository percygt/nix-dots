{
  username,
  lib,
  config,
  pkgs,
  ...
}: {
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

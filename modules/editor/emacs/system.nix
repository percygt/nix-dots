{
  username,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [./emacs.nix];
  options.editor = {
    emacs.system.enable = lib.mkEnableOption "Enable emacs systemwide";
    emacs.package = lib.mkOption {
      description = "emacs package to use";
      default = pkgs.emacs-unstable-pgtk.override {withTreeSitter = true;};
      type = lib.types.package;
    };
  };
  config = lib.mkIf config.editor.emacs.system.enable {
    environment.persistence = lib.mkIf config.core.ephemeral.enable {
      "/persist" = {
        users.${username} = {
          directories = [
            ".local/share/emacs"
            ".local/cache/emacs"
          ];
        };
      };
    };
    # home-manager.users.${username} = {
    #   imports = [./home.nix];
    #   editor.emacs.home.enable = lib.mkDefault true;
    # };
  };
}

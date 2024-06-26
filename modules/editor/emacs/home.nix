{
  pkgs,
  lib,
  config,
  ...
}: {
  options.editor.emacs.home.enable = lib.mkEnableOption "Enable emacs home";
  config = lib.mkIf config.editor.emacs.home.enable {
    programs.emacs = {
      package = pkgs.emacs-unstable-pgtk;
      enable = true;
      # extraPackages = epkgs:
      #   with epkgs; [
      #     wal-mode
      #     nix-mode
      #     magit
      #     tramp
      #     notmuch
      #     offlineimap
      #     org
      #     direnv
      #   ];
    };
    # services.emacs = {
    #   enable = true;
    #   startWithUserSession = "graphical";
    # };

    programs.offlineimap.enable = true;
  };
}

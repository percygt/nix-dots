{pkgs, ...}: {
  programs.emacs = {
    package = pkgs.emacs-unstable-pgtk;
    enable = true;
    extraPackages = epkgs:
      with epkgs; [
        wal-mode
        nix-mode
        magit
        tramp
        notmuch
        offlineimap
        org
        direnv
        doom
      ];
  };
  services.emacs = {
    enable = true;
    startWithUserSession = "graphical";
  };

  programs.offlineimap.enable = true;
}

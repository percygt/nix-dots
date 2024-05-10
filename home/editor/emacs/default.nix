{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options.editor.emacs = {
    enable = lib.mkEnableOption "Enable emacs";
  };

  config = lib.mkIf config.editor.emacs.enable {
    nixpkgs.overlays = [inputs.emacs-overlay.overlay];
    home.packages = with pkgs; [
      ## Doom dependencies
      git
      ripgrep
      gnutls # for TLS connectivity

      ## Optional dependencies
      fd # faster projectile indexing
      imagemagick # for image-dired
      zstd # for undo-fu-session/undo-tree compression

      # go-mode
      # gocode # project archived, use gopls instead

      ## Module dependencies
      # :checkers spell
      (aspellWithDicts (ds: with ds; [en en-computers en-science]))
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools lookup & :lang org +roam
      sqlite
      # :lang latex & :lang org (latex previews)
      # texlive.combined.scheme-medium
    ];
  };
}

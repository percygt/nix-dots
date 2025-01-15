pkgs: with pkgs; [
  # straight-el # NOTE not being used
  ## binaries
  # dirvish deps
  poppler_utils
  poppler
  ffmpegthumbnailer
  mediainfo
  gnutar
  unzip
  eza
  binutils # native-comp needs 'as', provided by this
  ## Dependencies
  libtool
  git
  ripgrep
  gnutls # for TLS connectivity
  ## Optional dependencies
  fd # faster projectile indexing
  imagemagick # for image-dired
  # (lib.mkIf config.programs.gnupg.agent.enable pinentry-emacs) # in-emacs gnupg prompts
  zstd # for undo-fu-session/undo-tree compression
  ## Module dependencies
  # :email mu4e
  mu
  isync
  maim
  # :checkers spell
  (aspellWithDicts (
    dicts: with dicts; [
      en
      en-computers
      en-science
      es
    ]
  ))
  # :tools editorconfig
  editorconfig-core-c # per-project style config
  # :tools lookup & :lang org +roam
  sqlite
  # :lang beancount
  beancount
  fava
  # :lang nix
  age
  # :lang latex
  graphviz
  (texlive.combine {
    inherit (pkgs.texlive)
      dvisvgm
      dvipng # for preview and export as html
      wrapfig
      amsmath
      ulem
      hyperref
      capt-of
      scheme-minimal
      latex-bin
      latexmk
      tools
      pgf
      epstopdf-pkg
      nicematrix
      infwarerr
      grfext
      kvdefinekeys
      kvsetkeys
      kvoptions
      ltxcmds
      ;
  })
]

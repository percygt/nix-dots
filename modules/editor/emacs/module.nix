{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.editor.emacs;
  # emacsConfig = pkgs.concatTextFile {
  #   name = "config.el";
  #   files = map (dir: ./config/${dir}) (builtins.attrNames (builtins.readDir ./config));
  # };
  org-tangle-elisp-blocks =
    (pkgs.callPackage ./org.nix {
      inherit pkgs;
      from-elisp = import ./from-elisp.nix;
    }).org-tangle
      (
        { language, flags }:
        let
          is-elisp = (language == "emacs-lisp") || (language == "elisp");
          is-tangle = if flags ? ":tangle" then flags.":tangle" == "yes" || flags.":tangle" == "y" else false;
        in
        is-elisp && is-tangle
      );
  extraPackages = import ./extraPackages.nix { inherit pkgs; };
  extraEmacsPackages =
    epkgs: with epkgs; [
      # required stuff
      treesit-grammars.with-all-grammars
      emacsql
      emacsql-sqlite
      (trivialBuild {
        pname = "eglot-booster";
        version = "0.1.0";
        src = pkgs.fetchFromGitHub {
          owner = "jdtsmith";
          repo = "eglot-booster";
          rev = "e19dd7ea81bada84c66e8bdd121408d9c0761fe6";
          hash = "sha256-vF34ZoUUj8RENyH9OeKGSPk34G6KXZhEZozQKEcRNhs=";
        };
      })
      (trivialBuild {
        pname = "nursery";
        version = "2024-10-05";
        src = pkgs.fetchFromGitHub {
          owner = "chrisbarrett";
          repo = "nursery";
          rev = "00a169c75b934a2eb42ea8620e8eebf34577d4ca";
          hash = "sha256-x+/TTSdHzQ+GKHV6jgvoQrwZCH4cZQfQGKDIBzFbJRw=";
        };
        sourceRoot = "source/lisp";
        packageRequires = with epkgs; [
          async
          org-drill
          pcre2el
          ts
          f
          ht
          dash
          org-roam
          memoize
          magit
          consult
          org-transclusion
        ];
        preBuild = ''
          rm nursery-pkg.el
        '';
      })
    ];

  emacs = pkgs.emacsWithPackagesFromUsePackage {
    inherit (cfg) package;
    inherit extraEmacsPackages;
    alwaysEnsure = true;
    config = pkgs.writeText "config.el" (org-tangle-elisp-blocks (builtins.readFile ./init.org));
    # config = builtins.readFile emacsConfig;
  };

  emacsWithExtraPackages = pkgs.runCommand "emacs" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
    makeWrapper ${emacs}/bin/emacsclient $out/bin/emacsclient --prefix PATH : ${lib.makeBinPath extraPackages}
    makeWrapper ${emacs}/bin/emacs $out/bin/emacs --prefix PATH : ${lib.makeBinPath extraPackages}
    mkdir -p $out/share/applications
    ln -vs ${emacs}/share/applications/emacs.desktop $out/share/applications
    ln -vs ${emacs}/share/applications/emacsclient.desktop $out/share/applications
    ln -vs ${emacs}/share/icons $out/share/icons
    ln -vs ${emacs}/share/info $out/share/info
    ln -vs ${emacs}/share/man $out/share/man
  '';
in
{
  options.modules.editor = {
    emacs = {
      enable = lib.mkEnableOption "Enable emacs systemwide";
      package = lib.mkOption {
        description = "Emacs package to use";
        default = pkgs.emacs-pgtk;
        type = lib.types.package;
      };
      finalPackage = lib.mkOption {
        description = "Emacs final package to use";
        default = emacsWithExtraPackages;
        type = lib.types.package;
      };
    };
  };
}

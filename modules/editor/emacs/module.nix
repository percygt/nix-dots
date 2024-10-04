{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.editor.emacs;
  emacsConfig = pkgs.concatTextFile {
    name = "config.el";
    files = map (dir: ./config/${dir}) (builtins.attrNames (builtins.readDir ./config));
  };
  extraPackages = import ./extraPackages.nix { inherit pkgs; };
  extraEmacsPackages =
    epkgs: with epkgs; [
      # required stuff
      treesit-grammars.with-all-grammars
      dash
      emacsql
      emacsql-sqlite
      magit-section
      s
      f
      ht
      ts
      async
      org-drill
      pcre2el
      ts
      # Install copilot.el
      (trivialBuild {
        pname = "welcome-dashboard";
        version = "2024-10-03";

        packageRequires = with epkgs; [
          async
          nerd-icons
          all-the-icons
        ];

        src = pkgs.fetchFromGitHub {
          owner = "konrad1977";
          repo = "welcome-dashboard";
          rev = "b4f3d6084e697533369cbb58f27930c7dc72e7f7";
          hash = "sha256-LhWmzfl8JHepYXecHkXGzqnQDB3lEJlGHc0EIh8ECPk=";
        };
      })
    ];
  emacs = pkgs.emacsWithPackagesFromUsePackage {
    inherit (cfg) package;
    inherit extraEmacsPackages;
    alwaysEnsure = true;
    config = builtins.readFile emacsConfig;
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

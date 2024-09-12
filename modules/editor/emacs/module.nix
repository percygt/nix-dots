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
        description = "emacs package to use";
        default = pkgs.emacs29-pgtk;
        type = lib.types.package;
      };
      finalPackage = lib.mkOption {
        description = "emacs finalpackage to use";
        default = emacsWithExtraPackages;
        type = lib.types.package;
      };
    };
  };
}

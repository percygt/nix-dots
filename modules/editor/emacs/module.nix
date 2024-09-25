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
    # mkdir -p $out/share
    # ln -vs ${emacs}/share/icons $out/share/icons
    # ln -vs ${emacs}/share/info $out/share/info
    # ln -vs ${emacs}/share/man $out/share/man
  '';
  editorScript = pkgs.writeShellScriptBin "emacseditor" ''
    if [ -z "$1" ]; then
      exec ${cfg.finalPackage}/bin/emacsclient --create-frame --alternate-editor ${cfg.finalPackage}/bin/emacs
    else
      exec ${cfg.finalPackage}/bin/emacsclient --alternate-editor ${cfg.finalPackage}/bin/emacs "$@"
    fi
  '';
in
{
  options.modules.editor = {
    emacs = {
      enable = lib.mkEnableOption "Enable emacs systemwide";
      package = lib.mkOption {
        description = "Emacs package to use";
        default = pkgs.emacs-unstable;
        type = lib.types.package;
      };
      editorScript = lib.mkOption {
        description = "Editor Script";
        default = editorScript;
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

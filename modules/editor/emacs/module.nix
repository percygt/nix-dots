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

  emacs = pkgs.emacsWithPackagesFromUsePackage {
    inherit (cfg) package;
    alwaysEnsure = true;
    config = builtins.readFile emacsConfig;
    extraEmacsPackages = epkgs: [ epkgs.treesit-grammars.with-all-grammars ] ++ extraPackages;
    override = eself: esuper: {
      nursery = eself.trivialBuild {
        pname = "nursery";
        version = "2024-09-07-git";
        src = pkgs.fetchFromGitHub {
          owner = "chrisbarrett";
          repo = "nursery";
          rev = "00a169c75b934a2eb42ea8620e8eebf34577d4ca";
          hash = "sha256-x+/TTSdHzQ+GKHV6jgvoQrwZCH4cZQfQGKDIBzFbJRw=";
        };
      };
    };
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
        default = pkgs.emacs-unstable-pgtk;
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

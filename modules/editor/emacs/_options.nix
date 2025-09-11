{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.editor.emacs;
  devCfg = config.modules.dev.tools.codingPackages;
  extraPackages =
    devCfg
    ++ (import ./.extraPackages.nix pkgs)
    ++ [
      (pkgs.emacs-lsp-booster.overrideAttrs (_: {
        nativeCheckInputs = [ emacs ]; # override emacs pkg for tests/bytecode_test
      }))
    ];

  emacs = cfg.package;
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
        default = pkgs.emacs-unstable;
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

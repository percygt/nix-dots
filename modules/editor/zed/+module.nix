{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.editor.zed;
  zedEditorWithExtraPackages = pkgs.symlinkJoin {
    name = "${lib.getName cfg.package}-wrapped-${lib.getVersion cfg.package}";
    paths = [ cfg.package ];
    preferLocalBuild = true;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/zeditor \
        --suffix PATH : ${lib.makeBinPath config.modules.dev.tools.editorExtraPackages}
    '';
  };
in
{
  options.modules.editor = {
    zed = {
      enable = lib.mkEnableOption "Zed, the high performance, multiplayer code editor from the creators of Atom and Tree-sitter";
      package = lib.mkPackageOption pkgs "zed-editor" { };

      finalPackage = lib.mkOption {
        description = "Emacs final package to use";
        default = zedEditorWithExtraPackages;
        type = lib.types.package;
      };
    };
  };
}

{ lib, pkgs, ... }:
{
  options.modules.editor = {
    emacs.enable = lib.mkEnableOption "Enable emacs systemwide";
    emacs.package = lib.mkOption {
      description = "emacs package to use";
      default = pkgs.emacs-unstable-pgtk;
      type = lib.types.package;
    };
  };
}

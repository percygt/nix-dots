{ lib, pkgs, ... }:
{
  options.modules.editor = {
    lazyvim.enable = lib.mkEnableOption "Enable neovim";
    lazyvim.package = lib.mkOption {
      description = "neovim package";
      default = pkgs.neovim-unwrapped;
      # default = pkgs.neovim-unstable;
      type = lib.types.package;
    };
  };
}

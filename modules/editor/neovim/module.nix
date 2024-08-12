{ lib, pkgs, ... }:
{
  options.modules.editor = {
    neovim.enable = lib.mkEnableOption "Enable neovim";
    neovim.package = lib.mkOption {
      description = "neovim package";
      default = pkgs.neovim-unstable;
      type = lib.types.package;
    };
  };
}

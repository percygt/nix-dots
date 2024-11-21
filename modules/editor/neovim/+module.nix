{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.modules.editor = {
    neovim = {
      enable = lib.mkEnableOption "Enable neovim";
      package = lib.mkOption {
        description = "neovim package";
        default = pkgs.neovim-unwrapped;
        # default = pkgs.neovim-unstable;
        type = lib.types.package;
      };
      lazyvim.enable = lib.mkOption {
        description = "LazyVim";
        default = !config.modules.editor.neovim.vanilla.enable;
        type = lib.types.bool;
      };
      vanilla.enable = lib.mkOption {
        description = "Vanilla";
        default = false;
        type = lib.types.bool;
      };
    };
  };
}

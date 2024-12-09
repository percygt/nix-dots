{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.modules.editor.neovim.enable {
    programs.neovim = {
      extraLuaPackages =
        luaPkgs: with luaPkgs; [
          jsregexp
          magick
          luacheck
        ];
      extraPackages = import ../+common.nix pkgs;
    };
  };
}

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
      extraPackages =
        (with pkgs; [
          nodejs
          yarn
          imagemagick
          nodePackages.npm
          nodePackages.pnpm
          # nodePackages.neovim
          vscode-extensions.vadimcn.vscode-lldb.adapter
          fswatch
          gnumake
          cmake
          git
          mercurial

          #dashboard
          cowsay
          fortune-kind

          # Telescope dependencies
          manix
          fzf
          ripgrep
          fd
        ])
        ++ (import ../+extras/commonPackages.nix pkgs);
    };
  };
}

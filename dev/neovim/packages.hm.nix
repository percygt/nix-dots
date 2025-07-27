{
  pkgs,
  config,
  ...
}:
{
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
        vscode-extensions.vadimcn.vscode-lldb.adapter
        fswatch
        gnumake
        curl
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
      ++ config.modules.dev.tools.editorExtraPackages;
  };
}

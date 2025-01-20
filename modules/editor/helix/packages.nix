{
  pkgs,
  config,
  lib,
  self,
  ...
}:
{
  config = lib.mkIf config.modules.editor.helix.enable {
    programs.helix = {
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

          fzf
          ripgrep
          fd
        ])
        ++ (import "${self}/modules/dev/+extras/langPackages.nix" pkgs);
    };
  };
}

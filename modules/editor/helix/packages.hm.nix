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
          fswatch
          gnumake
          cmake
          git
          mercurial

          fzf
          ripgrep
          fd
        ])
        # ++ (import "${self}/modules/dev/+extras/langPackages.nix" pkgs);
        ++ config.modules.dev.tools.codingPackages;
    };
  };
}

{
  pkgs,
  lib,
  config,
  flakeDirectory,
  libx,
  ...
}: let
  inherit (libx) colors;
in {
  options.editor.neovim.home.enable = lib.mkEnableOption "Enable neovim home";
  config = lib.mkIf config.editor.neovim.home.enable {
    home.shellAliases.v = "nvim";
    xdg.desktopEntries = {
      neovim = {
        name = "Neovim";
        genericName = "Text Editor";
        exec = let
          app = pkgs.writeShellScript "neovim-terminal" ''
            # Killing foot from sway results in non-zero exit code which triggers
            # xdg-mime to use next valid entry, so we must always exit successfully
            if [ "$SWAYSOCK" ]; then
              foot -- nvim "$1" || true
            else
              gnome-terminal -- nvim "$1" || true
            fi
          '';
        in "${app} %U";
        terminal = false;
        categories = ["Utility" "TextEditor"];
        mimeType = ["text/markdown" "text/plain" "text/javascript"];
      };
    };
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimdiffAlias = true;
      vimAlias = true;
      viAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = false;
      extraLuaConfig = ''
        if vim.loader then
          vim.loader.enable()
        end
        require("config.general")
        require("config.remaps")
        require("config.autocmds")
        require("config.tools.misc")
        require("config.ui.misc")
      '';
      inherit (import ./plugins.nix {inherit pkgs;}) plugins;
      inherit
        (import ./packages.nix {inherit pkgs;})
        extraPackages
        extraLuaPackages
        extraPython3Packages
        ;
    };
    home = {
      activation = let
        hmNvim = "${flakeDirectory}/modules/editor/neovim";
      in {
        linkNvim =
          lib.hm.dag.entryAfter ["linkGeneration"]
          ''
            [ -e "${config.xdg.configHome}/nvim/lua" ] || mkdir -p "${config.xdg.configHome}/nvim/lua/config"
            [ -e "${config.xdg.configHome}/nvim/spell" ] || ln -s ${hmNvim}/spell ${config.xdg.configHome}/nvim/spell
            [ -e "${config.xdg.configHome}/nvim/ftdetect" ] || ln -s ${hmNvim}/ftdetect ${config.xdg.configHome}/nvim/ftdetect
            [ -e "${config.xdg.configHome}/nvim/lua/config" ] && cp -rs ${hmNvim}/lua/config/. ${config.xdg.configHome}/nvim/lua/config/
          '';
      };
    };
    xdg.configFile = {
      # "nvim/lua" = {
      #   recursive = true;
      #   source = ./config/lua;
      # };
      # "nvim/ftdetect" = {
      #   recursive = true;
      #   source = ./config/ftdetect;
      # };
      "nvim/lua/config/colors.lua" = {
        text = ''
          return {
            bg0 = "#${colors.normal.black}",
            bg1 = "#${colors.bright.black}",
            bg2 = "#${colors.extra.nocturne}",
            bg3 = "#${colors.extra.azure}",
            bg_d = "#${colors.extra.obsidian}",
            fg = "#${colors.default.foreground}",
            yellow = "#${colors.normal.yellow}",
            cyan = "#${colors.normal.cyan}",
            matchParen = "#${colors.extra.azure}",

            midnight = "#${colors.extra.midnight}",
            cream = "#${colors.extra.cream}",
            lavender = "#${colors.extra.lavender}",
            rosewater = "#${colors.extra.rosewater}",
            peach = "#${colors.extra.peach}",
            sapphire = "#${colors.extra.sapphire}",
            sky = "#${colors.extra.sky}",
            mauve = "#${colors.extra.mauve}",
          }
        '';
      };
    };
  };
}

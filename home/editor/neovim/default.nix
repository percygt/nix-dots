{
  pkgs,
  lib,
  config,
  flakeDirectory,
  ui,
  ...
}: let
  inherit (ui) colors;
in {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly.overrideAttrs (_: {CFLAGS = "-O3";});
    defaultEditor = true;
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
    inherit (import ./packages.nix {inherit pkgs;}) extraPackages;
  };
  home = {
    activation = let
      HM_NVIM = "${flakeDirectory}/home/editor/neovim/config";
    in {
      linkNvimSpell =
        lib.hm.dag.entryAfter ["linkGeneration"]
        ''
          [ -e "${config.xdg.configHome}/nvim/spell" ] || ln -s "${HM_NVIM}/spell" "${config.xdg.configHome}/nvim/spell"
        '';
    };
  };
  xdg.configFile = {
    "nvim/lua" = {
      recursive = true;
      source = ./config/lua;
    };
    "nvim/ftdetect" = {
      recursive = true;
      source = ./config/ftdetect;
    };
    "nvim/lua/config/colors.lua" = {
      text = ''
        return {
          bg0 = "#${colors.normal.black}",
          bg1 = "#${colors.bright.black}",
          bg2 = "#${colors.extra.nocturne}",
          bg3 = "#${colors.extra.azure}",
          bg_d = "#${colors.extra.obsidian}",
          fg = "#${colors.default.foreground}",
          -- yellow = "#${colors.normal.yellow}",
          cyan = "#${colors.normal.cyan}",
          matchParen = "#${colors.extra.azure}",
          midnight = "#${colors.extra.midnight}",
          cream = "#${colors.extra.cream}",

          -- Catpuccin stuff
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
}

{
  pkgs,
  lib,
  config,
  profile,
  username,
  desktop,
  ...
}:
let
  g = config._global;
  configNvim = "${g.flakeDirectory}/config/dev/neovim/lazyvim";
in
{
  home.shellAliases.v = "nvim";
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    vimAlias = true;
    viAlias = true;
    # withNodeJs = true;
    withPython3 = true;
    withRuby = false;
    extraLuaConfig = lib.concatStringsSep "\n" [
      ''
        vim.g.gcc_bin_path = '${lib.getExe pkgs.gcc}'
        vim.g.sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'
      ''
      (lib.readFile ./lazyvim/init.lua)
    ];
  };
  home = {
    file."${g.flakeDirectory}/.neoconf.json".text =
      let
        flake = ''builtins.getFlake "${g.flakeDirectory}"'';
      in
      builtins.toJSON {
        lspconfig.nixd.nixd = {
          nixpkgs.expr = ''import (${flake}).inputs.nixpkgs {}'';
          options = {
            nixos.expr = ''(${flake}).nixosConfigurations."${profile}".options'';
            home-manager.expr = ''(${flake}).homeConfigurations."${username}@${profile}".options'';
          };
        };
      };
  };
  xdg = {
    configFile =
      let
        symlink = file: config.lib.file.mkOutOfStoreSymlink file;
      in
      {
        "nvim/lua/config/system.lua".text = g.textEditor.nvim."system.lua";
        "nvim/lazy-lock.json".source = symlink "${configNvim}/lazy-lock.json";
        "nvim/neoconf.json".source = symlink "${configNvim}/neoconf.json";
        "nvim/lazyvim.json".source = symlink "${configNvim}/lazyvim.json";
        "nvim/spell".source = symlink "${configNvim}/spell";
        "nvim/ftdetect".source = symlink "${configNvim}/ftdetect";
        "nvim/lua/plugins".source = symlink "${configNvim}/lua/plugins";
        "nvim/lua/utils".source = symlink "${configNvim}/lua/utils";
        "nvim/lua/config/autocmds.lua".source = symlink "${configNvim}/lua/config/autocmds.lua";
        "nvim/lua/config/icons.lua".source = symlink "${configNvim}/lua/config/icons.lua";
        "nvim/lua/config/lazy.lua".source = symlink "${configNvim}/lua/config/lazy.lua";
        "nvim/lua/config/lsp-servers.lua".source = symlink "${configNvim}/lua/config/lsp-servers.lua";
        "nvim/lua/config/options.lua".source = symlink "${configNvim}/lua/config/options.lua";
        "nvim/lua/config/keymaps.lua".source = symlink "${configNvim}/lua/config/keymaps.lua";
        "nvim/lua/config/colors.lua".source = symlink "${configNvim}/lua/config/colors.lua";
      };
    desktopEntries = {
      neovim = lib.mkIf (desktop != null) {
        name = "Neovim";
        genericName = "Text Editor";
        exec =
          let
            app = pkgs.writeShellScript "neovim-terminal" ''
              footclient -- nvim "$1" || true
            '';
          in
          "${app} %U";
        terminal = false;
        categories = [
          "Utility"
          "TextEditor"
        ];
        mimeType = [
          "text/markdown"
          "text/plain"
          "text/javascript"
        ];
      };
    };
  };
}

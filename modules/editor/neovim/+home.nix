{
  pkgs,
  lib,
  config,
  profile,
  username,
  ...
}:
let
  g = config._base;
  cfg = config.modules.editor.neovim;
  nvimDir = if cfg.vanilla.enable then "vanilla" else "lazyvim";
  moduleNvim = "${g.flakeDirectory}/modules/editor/neovim/${nvimDir}";
in
{
  imports = [ ./packages.nix ];
  config = lib.mkIf cfg.enable {
    home.shellAliases.v = "nvim";
    programs.neovim = {
      enable = true;
      inherit (cfg) package;
      defaultEditor = true;
      vimdiffAlias = true;
      vimAlias = true;
      viAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = false;
      extraLuaConfig = lib.concatStringsSep "\n" [
        ''
          vim.g.gcc_bin_path = '${lib.getExe pkgs.gcc}'
          vim.g.sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'
        ''
        (lib.readFile ./${nvimDir}/init.lua)
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
      activation = {
        lazyRestore =
          lib.hm.dag.entryAfter [ "linkGeneration" ]
            # bash
            ''
              # setup lazy.nvim
              LAZYNVIM_DIR="$XDG_DATA_HOME/nvim/lazy/lazy.nvim"
              LAZYNVIM_URL="https://github.com/folke/lazy.nvim"
              if [ ! -d $LAZYNVIM_DIR ];then
                ${lib.getExe config._base.dev.git.package} clone --filter=blob:none --branch=stable "$LAZYNVIM_URL" "$LAZYNVIM_DIR"
              fi

              LOCK_FILE=$(readlink -f $XDG_CONFIG_HOME/nvim/lazy-lock.json)
              echo $LOCK_FILE
              [ ! -f "$LOCK_FILE" ] && echo "No lock file found, skipping" && exit 0

              STATE_DIR=$XDG_STATE_HOME/nix/
              STATE_FILE=$STATE_DIR/lazy-lock-checksum

              [ ! -d $STATE_DIR ] && mkdir -p $STATE_DIR
              [ ! -f $STATE_FILE ] && touch $STATE_FILE

              HASH=$(nix-hash --flat $LOCK_FILE)

              if [ "$(cat $STATE_FILE)" != "$HASH" ]; then
                $DRY_RUN_CMD echo "Syncing neovim plugins"
                ${config.programs.neovim.finalPackage}/bin/nvim --headless "+Lazy! restore" +qa
                $DRY_RUN_CMD echo $HASH >$STATE_FILE
              else
                $VERBOSE_ECHO "Neovim plugins already synced, skipping"
              fi
            '';
      };
    };
    xdg = {
      configFile = {
        "nvim/lua/config/private.lua".text = g.editor.nvim."private.lua";
        "nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/lazy-lock.json";
        "nvim/neoconf.json".source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/neoconf.json";
        "nvim/spell".source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/spell";
        "nvim/ftdetect".source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/ftdetect";
        "nvim/lua/plugins".source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/lua/plugins";
        "nvim/lua/utils".source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/lua/utils";
        "nvim/lua/config/autocmds.lua".source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/lua/config/autocmds.lua";
        "nvim/lua/config/icons.lua".source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/lua/config/icons.lua";
        "nvim/lua/config/lazy.lua".source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/lua/config/lazy.lua";
        "nvim/lua/config/lsp-servers.lua".source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/lua/config/lsp-servers.lua";
        "nvim/lua/config/options.lua".source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/lua/config/options.lua";
        "nvim/lua/config/keymaps.lua".source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/lua/config/keymaps.lua";
        "nvim/lazyvim.json" = lib.mkIf cfg.lazyvim.enable {
          source = config.lib.file.mkOutOfStoreSymlink "${moduleNvim}/lazyvim.json";
        };
        # Nixd LSP configuration
        "nvim/lua/config/colorscheme.lua" =
          let
            colorschemeLua =
              pkgs.runCommand "colorscheme.lua" { }
                #bash
                ''
                  ${pkgs.yq-go}/bin/yq -o=lua 'del(.scheme) |
                      del(.author) |
                      del(.name) |
                      del(.slug) |
                      del(.system) |
                      del(.variant) |
                      .[] |= "#" + .' ${config.modules.themes.colors} > $out
                '';
          in
          {
            text = builtins.readFile colorschemeLua;
          };
      };
      desktopEntries = {
        neovim = {
          name = "Neovim";
          genericName = "Text Editor";
          exec =
            let
              app = pkgs.writeShellScript "neovim-terminal" ''
                # Killing foot from sway results in non-zero exit code which triggers
                # xdg-mime to use next valid entry, so we must always exit successfully
                if [ "$SWAYSOCK" ]; then
                  footclient -- nvim "$1" || true
                else
                  tilix -- nvim "$1" || true
                fi
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
  };
}

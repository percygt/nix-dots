{
  pkgs,
  lib,
  config,
  flakeDirectory,
  ...
}:
let
  hmNvim = "${flakeDirectory}/modules/editor/neovim";
in
{
  options.editor.neovim.home.enable = lib.mkEnableOption "Enable neovim home";
  config = lib.mkIf config.editor.neovim.home.enable {
    home.shellAliases.v = "nvim";
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimdiffAlias = true;
      vimAlias = true;
      viAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = false;
      extraWrapperArgs = [
        "--prefix"
        "LD_LIBRARY_PATH"
        ":"
        "${lib.makeLibraryPath [
          pkgs.libgit2
          pkgs.gpgme
        ]}"
      ];

      extraLuaConfig =
        # lua
        ''
          vim.g.gcc_bin_path = '${lib.getExe pkgs.gcc}'
          vim.g.sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'
          require("config.options")
          require("config.remaps")
          require("config.autocmds")
          require("config.lazy")
        '';
      plugins = [
        pkgs.vimPlugins.lazy-nvim # All other plugins are managed by lazy-nvim
      ];
      extraLuaPackages =
        luaPkgs: with luaPkgs; [
          jsregexp
          magick
        ];
      extraPackages = import ./packages.nix { inherit pkgs; };
    };
    home = {
      activation = {
        linkNvim =
          lib.hm.dag.entryAfter [ "linkGeneration" ]
            # bash
            ''
              [ -e "${config.xdg.configHome}/nvim" ] || mkdir -p "${config.xdg.configHome}/nvim/lua/config"
              [ -e "${config.xdg.configHome}/nvim/lua/config" ] && cp -rs ${hmNvim}/lua/config/. ${config.xdg.configHome}/nvim/lua/config/
              [ -e "${config.xdg.configHome}/nvim/lua/plugins" ] || ln -s ${hmNvim}/lua/plugins ${config.xdg.configHome}/nvim/lua/plugins
              [ -e "${config.xdg.configHome}/nvim/lua/utils" ] || ln -s ${hmNvim}/lua/utils ${config.xdg.configHome}/nvim/lua/utils
              [ -e "${config.xdg.configHome}/nvim/spell" ] || ln -s ${hmNvim}/spell ${config.xdg.configHome}/nvim/spell
              [ -e "${config.xdg.configHome}/nvim/ftdetect" ] || ln -s ${hmNvim}/ftdetect ${config.xdg.configHome}/nvim/ftdetect
            '';
        neovim =
          lib.hm.dag.entryAfter [ "linkGeneration" ]
            # bash
            ''
              LOCK_FILE=$(readlink -f ~/.config/nvim/lazy-lock.json)
              echo $LOCK_FILE
              [ ! -f "$LOCK_FILE" ] && echo "No lock file found, skipping" && exit 0

              STATE_DIR=~/.local/state/nix/
              STATE_FILE=$STATE_DIR/lazy-lock-checksum

              [ ! -d $STATE_DIR ] && mkdir -p $STATE_DIR
              [ ! -f $STATE_FILE ] && touch $STATE_FILE

              HASH=$(nix-hash --flat $LOCK_FILE)

              if [ "$(cat $STATE_FILE)" != "$HASH" ]; then
                echo "Syncing neovim plugins"
                $DRY_RUN_CMD ${config.programs.neovim.finalPackage}/bin/nvim --headless "+Lazy! restore" +qa
                $DRY_RUN_CMD echo $HASH >$STATE_FILE
              else
                $VERBOSE_ECHO "Neovim plugins already synced, skipping"
              fi
            '';
      };
    };
    xdg = {
      configFile = {
        "nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink "${hmNvim}/lazy-lock.json";
        # Nixd LSP configuration
        "${flakeDirectory}/.nixd.json".text = builtins.toJSON {
          options = {
            enable = true;
            target.installable = ".#homeConfigurations.nixd.options";
          };
        };
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
                      .[] |= "#" + .' ${config.setTheme.colors} > $out
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
                  foot -- nvim "$1" || true
                else
                  gnome-terminal -- nvim "$1" || true
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

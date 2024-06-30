{
  pkgs,
  inputs,
  lib,
  config,
  username,
  flakeDirectory,
  ...
}: let
  cfg = config.editor.emacs;
  extraBinPaths = with pkgs; [
    (python3.withPackages (ps:
      with ps; [
        python-lsp-server
        # pylsp-mypy
        python-lsp-ruff
      ]))
    # ruff
    # nodePackages.pyright

    # Lua
    lua-language-server
    stylua

    # Nix
    statix
    alejandra
    nil

    # C, C++
    clang-tools
    cppcheck

    # Shell scripting
    shfmt
    shellcheck
    shellharden

    # JavaScript
    deno
    prettierd
    eslint_d
    # nodePackages.prettier
    # nodePackages.typescript-language-server
    # nodePackages."@astrojs/language-server"
    # nodePackages.prettier-plugin-astro
    # nodePackages-extra.prettier-plugin-astro

    # Go
    go
    gopls
    golangci-lint
    delve
    go-tools
    gofumpt

    #clj
    leiningen
    babashka

    #docker
    hadolint

    #markdown
    marksman

    # Additional
    yamllint
    bash-language-server
    yaml-language-server
    dockerfile-language-server-nodejs
    vscode-langservers-extracted
    markdownlint-cli
    taplo-cli
    codespell
    gitlint
    terraform-ls
    actionlint
    parallel
    ripgrep
    fd
  ];
  # Function to wrap emacs to contain the path for language servers
  emacs = pkgs.emacsWithPackagesFromUsePackage {
    inherit (cfg) package;
    alwaysEnsure = true;
    config = ./config.el;
    extraEmacsPackages = epkgs:
      [epkgs.treesit-grammars.with-all-grammars]
      ++ extraBinPaths;
  };

  emacsWithLanguageServers = pkgs.runCommand "emacsWithLanguageServers" {nativeBuildInputs = [pkgs.makeWrapper];} ''
    makeWrapper ${emacs}/bin/emacs $out/bin/emacs --prefix PATH : ${lib.makeBinPath extraBinPaths}
  '';
in {
  config = lib.mkIf config.editor.emacs.system.enable {
    nixpkgs.overlays = [inputs.emacs-overlay.overlays.default];
    environment.systemPackages = [
      (pkgs.aspellWithDicts (dicts: with dicts; [en en-computers]))
      emacsWithLanguageServers
    ];
    fonts.packages = with pkgs; [
      (nerdfonts.override {fonts = ["VictorMono"];})
      emacs-all-the-icons-fonts
    ];
    home-manager.users.${username} = {
      lib,
      config,
      pkgs,
      ...
    }: {
      xdg.desktopEntries = {
        emacs = {
          name = "Emacs";
          type = "Application";
          genericName = "Text Editor";
          exec = "emacs %F";
          terminal = false;
          icon = "emacs";
          comment = "Edit text";
          categories = ["Development" "TextEditor"];
          startupNotify = true;
          settings = {
            StartupWMClass = "Emacs";
          };
          mimeType = [
            "text/english"
            "text/plain"
            "text/x-makefile"
            "text/x-c++hdr"
            "text/x-c++src"
            "text/x-chdr"
            "text/x-csrc"
            "text/x-java"
            "text/x-moc"
            "text/x-pascal"
            "text/x-tcl"
            "text/x-tex"
            "application/x-shellscript"
            "text/x-c"
            "text/x-c++"
          ];
        };
      };
      home = {
        activation = {
          linkEmacsConfig =
            lib.hm.dag.entryAfter ["linkGeneration"]
            ''
              [ -e "${config.xdg.configHome}/emacs" ] || mkdir "${config.xdg.configHome}/emacs"
              [ -e "${config.xdg.configHome}/emacs/init.el" ] || ln -s "${flakeDirectory}/modules/editor/emacs/config.el" "${config.xdg.configHome}/emacs/init.el"
              [ -e "${config.xdg.configHome}/emacs/early-init.el" ] || ln -s "${flakeDirectory}/modules/editor/emacs/early-init.el" "${config.xdg.configHome}/emacs/early-init.el"
            '';
        };
      };
    };
  };
}

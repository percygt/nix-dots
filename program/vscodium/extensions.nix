{
  pkgs,
  inputs,
  ...
}: let
  vscode-marketplace = (inputs.nix-vscode-extensions.extensions.${pkgs.system}).vscode-marketplace;
in {
  extensions = with pkgs.vscode-extensions;
  with vscode-marketplace; [
    adpyke.codesnap
    anderseandersen.html-class-suggestions
    antfu.iconify
    astro-build.astro-vscode
    vscodevim.vim
    # asvetliakov.vscode-neovim
    bbenoist.nix
    bernardogualberto.solidjs
    britesnow.vscode-toggle-quotes
    charliermarsh.ruff
    christian-kohler.npm-intellisense
    christian-kohler.path-intellisense
    codezombiech.gitignore
    dbaeumer.vscode-eslint
    donjayamanne.python-environment-manager
    esbenp.prettier-vscode
    formulahendry.auto-close-tag
    formulahendry.auto-rename-tag
    foxundermoon.shell-format
    github.vscode-pull-request-github
    gitlab.gitlab-workflow
    helixquar.randomeverything
    jock.svg
    kamadorueda.alejandra
    kastorcode.kastorcode-dark-purple-theme
    kevinrose.vsc-python-indent
    mads-hartmann.bash-ide-vscode
    mgesbert.python-path
    mikestead.dotenv
    mkhl.direnv
    mohsen1.prettify-json
    mrmlnc.vscode-scss
    ms-azuretools.vscode-docker
    ms-python.black-formatter
    ms-python.python
    ms-vscode-remote.remote-ssh
    ms-vscode.remote-explorer
    oderwat.indent-rainbow
    patbenatar.advanced-new-file
    pmneo.tsimporter
    pranaygp.vscode-css-peek
    redhat.vscode-yaml
    ritwickdey.liveserver
    sibiraj-s.vscode-scss-formatter
    simonsiefke.svg-preview
    sleistner.vscode-fileutils
    solnurkarim.html-to-css-autocompletion
    steoates.autoimport
    sumneko.lua
    tamasfe.even-better-toml
    timonwong.shellcheck
    usernamehw.errorlens
    vscode-icons-team.vscode-icons
    vunguyentuan.vscode-css-variables
    wallabyjs.console-ninja
    codium.codium
    johnnymorganz.stylua
  ];
}

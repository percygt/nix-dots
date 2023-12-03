{
  programs.vscode = {
    enable = true;
    enableUpdateCheck = true;
    mutableExtensionsDir = true;
    enableExtensionUpdateCheck = true;
    extensions = with pkgs.vscode-extensions; [
      jeanp413.open-remote-ssh
      codezombiech.gitignore
      ms-vscode.remote-explorer
      vunguyentuan.vscode-css-variables
      donjayamanne.python-extension-pack
      vscode-icons-team.vscode-icons
      znck.vue
      shyykoserhiy.git-autoconfig
      pmneo.tsimporter
      mgmcdermott.vscode-language-babel
      christian-kohler.path-intellisense
      ms-python.isort
      redhat.vscode-yaml
      sdras.vue-vscode-snippets
      dbaeumer.vscode-eslint
      christian-kohler.npm-intellisense
      ms-vscode.cpptools-themes
      ms-vscode.cpptools-extension-pack
      formulahendry.auto-rename-tag
      bernardogualberto.solidjs
      formulahendry.auto-close-tag
      bmalehorn.vscode-fish
      ms-vscode.live-server
      mohd-akram.vscode-html-format
      mgesbert.python-path
      kevinrose.vsc-python-indent
      kastorcode.kastorcode-dark-purple-theme
      mikestead.dotenv
      angelorafael.jsx-html-tags
      simonsiefke.svg-preview
      sleistner.vscode-fileutils
      njpwerner.autodocstring
      jock.svg
      batisteo.vscode-django
      formulahendry.code-runner
      sibiraj-s.vscode-scss-formatter
      anderseandersen.html-class-suggestions
      grapecity.gc-excelviewer
      mohsen1.prettify-json
      steoates.autoimport
      patbenatar.advanced-new-file
      oderwat.indent-rainbow
      styled-components.vscode-styled-components
      mrmlnc.vscode-scss
      pranaygp.vscode-css-peek
      solnurkarim.html-to-css-autocompletion
      ms-vscode.remote-repositories
      esbenp.prettier-vscode
      ritwickdey.liveserver
      usernamehw.errorlens
      bbenoist.nix
      antfu.iconify
      shakram02.bash-beautify
      mads-hartmann.bash-ide-vscode
      ms-python.python
      ms-vscode-remote.remote-containers
      astro-build.astro-vscode
      ms-python.flake8
      ms-python.vscode-pylance
      ms-python.black-formatter
      github.vscode-pull-request-github
      ms-azuretools.vscode-docker
      ms-vscode.cpptools
      mkhl.direnv
      kamadorueda.alejandra
      tamasfe.even-better-toml
      ms-vscode-remote.remote-ssh
      sumneko.lua
      vue.volar
      vue.vscode-typescript-vue-plugin
      bodil.prettier-toml
      gitlab.gitlab-workflow
      mechatroner.rainbow-csv
      donjayamanne.python-environment-manager
    ];
    userSettings = {
      "window.titleBarStyle" = "custom";
    };
  };
}

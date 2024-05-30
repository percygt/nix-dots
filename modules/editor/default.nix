{username, ...}: {
  home-manager.users.${username}.imports = [
    ./neovim
    ./emacs
    # ./vscode
  ];
}


{
  pkgs,
  ...
}:{
  home.packages = with pkgs; [
    git
    du-dust
    duf
    fd
    ripgrep
    curl
    wget
    pinentry-curses
  ];
}

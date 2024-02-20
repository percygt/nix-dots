{
  lib,
  ...
}: {
  programs.home-manager.enable = true;
  home.sessionVariables.EDITOR = "nvim";
  news = {
    display = "silent";
    json = lib.mkForce {};
    entries = lib.mkForce [];
  };
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };
  imports = [
    ./neovim
    ./shell
    ./terminal
    ./scripts
    ./tmux.nix
    ./vscodium.nix
    ./zellij.nix
    ./starship.nix
    ./yazi.nix
    ./broot.nix
    ./direnv.nix
    ./fastfetch.nix
    ./cli.nix
    ./nixtools.nix
    ./zathura.nix
  ];
}

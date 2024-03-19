{pkgs, ...}: {
  imports = [
    ./tmux.nix
    ./eza.nix
    ./nixtools.nix
    ./bat.nix
  ];
  home.packages = with pkgs; [
    git
    du-dust
    dua
    duf
    yq-go # portable command-line YAML, JSON and XML processor
    fd
    ripgrep
    unrar
    p7zip
    jq
    aria2
  ];
}

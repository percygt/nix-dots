{lib, ...}: {
  imports = [
    # can be enable/disable in profiles/${host}/home.nix
    # cli.${module_name}.enable = true

    # optional
    ./atuin.nix
    ./direnv.nix
    ./extra.nix
    ./starship.nix
    ./tui.nix
    ./yazi

    # enable true by default
    ./common.nix
    ./bat.nix
    ./eza.nix
    ./nixtools.nix
    ./tmux
  ];
  cli = {
    common.enable = lib.mkDefault true; #./common.nix
    bat.enable = lib.mkDefault true; #./bat.nix
    eza.enable = lib.mkDefault true; #./eza.nix
    nixtools.enable = lib.mkDefault true; #./nixtools.nix
    tmux.enable = lib.mkDefault true; #./tmux
  };
}

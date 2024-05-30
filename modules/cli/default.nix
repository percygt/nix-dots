{
  lib,
  username,
  ...
}: {
  home-manager.users.${username}.imports = [
    ./atuin.nix
    ./direnv.nix
    ./extra.nix
    ./starship.nix
    ./aria.nix
    ./ncmpcpp.nix
    ./tui.nix
    ./yazi

    # enable true by default
    ./common.nix
    ./bat.nix
    ./eza.nix
    ./nixtools.nix
    ./tmux
    {
      cli = {
        common.enable = lib.mkDefault true; #./common.nix
        bat.enable = lib.mkDefault true; #./bat.nix
        eza.enable = lib.mkDefault true; #./eza.nix
        nixtools.enable = lib.mkDefault true; #./nixtools.nix
        tmux.enable = lib.mkDefault true; #./tmux
      };
    }
  ];
}

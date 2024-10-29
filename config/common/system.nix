{ config, ... }:
let
  g = config._general;
in
{
  imports = [
    ./dconf
    ./ydotool.nix
    # ./blocky.nix
  ];
  home-manager.users.${g.username} = import ./home.nix;
  programs.xfconf.enable = true;
}

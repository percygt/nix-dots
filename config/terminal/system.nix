{
  config,
  pkgs,
  ...
}:
let
  g = config._general;
in
{
  home-manager.users.${g.username} = import ./home.nix;
  environment.systemPackages = with pkgs; [ foot ];
}

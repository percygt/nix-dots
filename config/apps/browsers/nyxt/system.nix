{
  config,
  ...
}:
let
  g = config._general;
in
{
  home-manager.users.${g.username} = import ./home.nix;
}

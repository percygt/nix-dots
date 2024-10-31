{ config, inputs, ... }:
let
  g = config._general;
in
{
  imports = [
    (builtins.toString inputs.general)
    ./module.nix
  ];
  # config.home-manager.users.${g.username} = import ./home.nix;
}

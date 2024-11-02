{ config, ... }:
let
  g = config._general;
in
{
  environment.systemPackages = [ g.terminal.foot.package ];
}

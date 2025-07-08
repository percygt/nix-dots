{ config, ... }:
let
  g = config._base;
in
{
  environment.systemPackages = [ g.terminal.default.package ];
}

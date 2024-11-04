{ config, ... }:
let
  g = config._base;
  nushellPkg = g.shell.nushell.package;
in
{
  programs.nushell = {
    enable = true;
    package = nushellPkg;
    envFile.source = ./+assets/env.nu;
    configFile.source = ./+assets/config.nu;
    inherit (config.home) shellAliases;
  };
}

{ config, ... }:
let
  g = config._base;
  defaultShell = g.shell.default.package;
in
{
  programs = {
    carapace = {
      enable = defaultShell == g.shell.nushell.package;
      enableFishIntegration = false;
      # Use custom integration
      enableNushellIntegration = false;
    };
  };
}

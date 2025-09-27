{ inputs, ... }:
{
  imports = [ inputs.system76-scheduler-niri.homeModules.default ];
  services.system76-scheduler-niri.enable = true;
}

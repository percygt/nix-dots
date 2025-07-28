{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules.security.sops;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}

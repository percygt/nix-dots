{
  pkgs,
  lib,
  config,
  ...
}:
let
  g = config._general;
in
{
  imports = [
    ./kernel.nix
    ./hardening.nix
    ./fprintd.nix
    ./module.nix
  ];
  config = lib.mkIf config.modules.security.common.enable {
    home-manager.users.${g.username} = import ./home.nix;
    environment.systemPackages = with pkgs; [
      age
      sops
    ];
  };
}

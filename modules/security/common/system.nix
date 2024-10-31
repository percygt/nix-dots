{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./kernel.nix
    ./hardening.nix
    ./fprintd.nix
    ./module.nix
  ];
  config = lib.mkIf config.modules.security.common.enable {
    environment.systemPackages = with pkgs; [
      age
      sops
    ];
  };
}

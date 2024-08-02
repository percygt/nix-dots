{
  pkgs,
  lib,
  config,
  username,
  libx,
  ...
}:
{
  imports = [
    ./kernel.nix
    ./hardening.nix
    ./fprintd.nix
  ];
  options.modules.security.common.enable = libx.enableDefault "common";
  config = lib.mkIf config.modules.security.common.enable {
    home-manager.users.${username} = import ./home.nix;
    environment.systemPackages = with pkgs; [
      age
      sops
    ];
  };
}

{
  config,
  stateVersion,
  pkgs,
  ...
}:
let
  g = config._base;

  inherit (g)
    security
    dev
    ;
in
{
  imports = [
    ./home-manager.nix
    ../shell
    ../cli
  ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  system.stateVersion = stateVersion;
  environment.packages = [
    pkgs.vim
    security.gpg.package
    security.ssh.package
    dev.git.package
  ];
  time.timeZone = "Asia/Manila";
}

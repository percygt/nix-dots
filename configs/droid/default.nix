{
  config,
  stateVersion,
  ...
}:
let
  g = config._base;
in
{
  imports = [
    ./home-manager.nix
    ../shell
  ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  system.stateVersion = stateVersion;
  environment.packages = g.system.corePackages;
  time.timeZone = "Asia/Manila";
}

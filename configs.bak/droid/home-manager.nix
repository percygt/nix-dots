{
  homeArgs,
  ...
}:
{
  home-manager = {
    config = ./home.nix;
    backupFileExtension = "home-manager.backup";
    useGlobalPkgs = true;
    extraSpecialArgs = homeArgs // {
      inherit homeArgs;
    };
  };

}

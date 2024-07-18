{
  username,
  inputs,
  homeArgs,
  config,
  ...
}:
{
  imports = [
    ./${username}
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = homeArgs // {
      nixosConfig = config;
    };
  };
}

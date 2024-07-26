{
  inputs,
  homeArgs,
  config,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = homeArgs // {
      nixosConfig = config;
    };
  };
}

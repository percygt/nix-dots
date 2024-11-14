{
  inputs,
  homeArgs,
  config,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    extraSpecialArgs = homeArgs // {
      inherit homeArgs;
      nixosConfig = config;
    };
  };
}

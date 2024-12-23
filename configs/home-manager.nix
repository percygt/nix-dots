{
  inputs,
  homeArgs,
  config,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    backupFileExtension = ".backup";
    extraSpecialArgs = homeArgs // {
      inherit homeArgs;
      nixosConfig = config;
    };
  };
}

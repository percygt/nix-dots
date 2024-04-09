{
  config,
  lib,
  inputs,
  username,
  profile,
  ...
}: {
  options = {
    core.home-manager = {
      enable =
        lib.mkEnableOption "Enable home-manager";
    };
  };

  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  config = lib.mkIf config.core.home-manager.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${username} = {
        imports = [
          ../profiles/${profile}/home.nix
          inputs.self.outputs.homeManagerModules.default
        ];
      };
    };
  };
}

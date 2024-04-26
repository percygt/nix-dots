{
  lib,
  username,
  inputs,
  outputs,
  homeArgs,
  profile,
  self,
  config,
  ...
}: let
  ifHomeExist = builtins.pathExists "${self}/profiles/${profile}/home.nix";
in {
  imports =
    lib.optionals (builtins.pathExists ./${username})
    [./${username}]
    ++ lib.optionals ifHomeExist
    [inputs.home-manager.nixosModules.home-manager];

  home-manager = lib.mkIf ifHomeExist {
    # useGlobalPkgs = true;
    # useUserPackages = true;
    extraSpecialArgs = homeArgs // {nixosConfig = config;};
    users.${username}.imports = [outputs.homeManagerModules.default];
  };
}

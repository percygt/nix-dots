{
  lib,
  username,
  inputs,
  outputs,
  homeArgs,
  profile,
  self,
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
    extraSpecialArgs = homeArgs;
    users.${username}.imports = [outputs.homeManagerModules.default];
  };
}

{
  self,
  profile,
  username,
  lib,
  isGeneric,
  inputs,
  ...
}: let
  dirImports = fileName:
    builtins.filter (path: builtins.pathExists path) (map (dir: ./${dir}/${fileName}.nix)
      (builtins.attrNames (removeAttrs (builtins.readDir ./.) ["default.nix"])))
    ++ ["${self}/profiles/${profile}/${fileName}.nix"];
in {
  imports = dirImports "default" ++ lib.optionals (! isGeneric) [inputs.sops-nix.nixosModules.sops];
  home-manager.users.${username}.imports = dirImports "home" ++ lib.optionals (! isGeneric) [inputs.sops-nix.homeManagerModules.sops];
}

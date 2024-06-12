{
  self,
  profile,
  username,
  ...
}: let
  dirImports = fileName:
    builtins.filter (path: builtins.pathExists path) (map (dir: ./${dir}/${fileName}.nix)
      (builtins.attrNames (removeAttrs (builtins.readDir ./.) ["default.nix"])))
    ++ ["${self}/profiles/${profile}/${fileName}.nix"];
in {
  imports = dirImports "default";
  home-manager.users.${username}.imports = dirImports "home";
}

{
  self,
  profile,
  username,
  ...
}: let
  dirImports = fileName:
    builtins.filter (path: builtins.pathExists path) (map (dir: ./${dir}/${fileName}.nix)
      (builtins.attrNames (removeAttrs (builtins.readDir ./.) ["default.nix"])));
in {
  imports =
    dirImports "default"
    ++ ["${self}/profiles/${profile}/configuration.nix"];

  home-manager.users.${username} = {
    imports =
      dirImports "home"
      ++ ["${self}/profiles/${profile}/home.nix"];
  };
}

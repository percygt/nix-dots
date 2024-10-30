{
  inputs,
  isGeneric,
  isIso,
}:
let
  lib = if isGeneric then inputs.home-manager.lib else inputs.nixpkgs.lib;
in
{
  sway = import ./sway.nix { inherit lib; };
  toRasi = import ./toRasi.nix { inherit lib; };
  mkLiteral = value: {
    _type = "literal";
    inherit value;
  };

  colorConvert = import ./colorCoversions.nix { nixpkgs-lib = lib; };
  importPaths = rec {
    moduleDefault =
      rootDir:
      if isGeneric then
        (if (builtins.pathExists (rootDir + /home.nix)) then [ (rootDir + /home.nix) ] else [ ])
      else
        (if (builtins.pathExists (rootDir + /system.nix)) then [ (rootDir + /system.nix) ] else [ ]);

    moduleAll =
      rootDir:
      builtins.filter (path: builtins.pathExists path) (
        map (f: rootDir + "/${f}") (
          builtins.attrNames (
            removeAttrs (builtins.readDir rootDir) [
              "default.nix"
              "home.nix"
              "system.nix"
            ]
          )
        )
      );

    default = rootDir: { imports = moduleDefault rootDir; };
    all = rootDir: { imports = moduleAll rootDir; };
  };

}

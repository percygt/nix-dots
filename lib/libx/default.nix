{
  inputs,
  isGeneric,
  isIso,
}:
let
  lib = if isGeneric then inputs.home-manager.lib else inputs.nixpkgs.lib;
in
{
  inherit (import ../../packages/args.nix) clj;
  sway = import ./sway.nix { inherit lib; };
  toRasi = import ./toRasi.nix { inherit lib; };
  mkLiteral = value: {
    _type = "literal";
    inherit value;
  };

  colorConvert = import ./colorCoversions.nix { nixpkgs-lib = lib; };
  inheritModule =
    {
      config,
      module,
      name,
    }:
    lib.mkIf config.modules."${name}"."${module}".enable {
      home-manager.users.${config._general.username}.modules."${name}"."${module}".enable = true;
    };
  enableDefault =
    n:
    lib.mkOption {
      description = "Enable ${n}";
      type = lib.types.bool;
      default = !isIso;
    };

  importPaths = rec {
    moduleDefault =
      rootDir:
      if isGeneric then
        (if (builtins.pathExists (rootDir + /home.nix)) then [ (rootDir + /home.nix) ] else [ ])
      else
        (if (builtins.pathExists (rootDir + /system.nix)) then [ (rootDir + /system.nix) ] else [ ]);
    default = rootDir: { imports = moduleDefault rootDir; };

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
    all = rootDir: { imports = moduleAll rootDir; };
  };

}

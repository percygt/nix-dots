{
  inputs,
  isGeneric,
  isDroid,
  homeMarker,
  username,
}:
let
  lib = inputs.home-manager.lib // inputs.nixpkgs.lib;
in
{
  sway = import ./sway.nix { inherit lib; };
  toRasi = import ./toRasi.nix { inherit lib; };
  mkLiteral = value: {
    _type = "literal";
    inherit value;
  };

  colorConvert = import ./colorCoversions.nix { nixpkgs-lib = lib; };
  importPaths =
    let
      importHomeDir =
        rootDir: if (builtins.pathExists (rootDir + /+home)) then moduleAll (rootDir + /+home) else [ ];
      importHomeFile =
        rootDir: if (builtins.pathExists (rootDir + /+home.nix)) then [ (rootDir + /+home.nix) ] else [ ];

      importSystemDir =
        rootDir: if (builtins.pathExists (rootDir + /+system)) then moduleAll (rootDir + /+system) else [ ];
      importSystemFile =
        rootDir:
        if (builtins.pathExists (rootDir + /+system.nix)) then [ (rootDir + /+system.nix) ] else [ ];

      importCommonDir =
        rootDir: if (builtins.pathExists (rootDir + /+common)) then moduleAll (rootDir + /+common) else [ ];
      importCommonFile =
        rootDir:
        if (builtins.pathExists (rootDir + /+common.nix)) then [ (rootDir + /+common.nix) ] else [ ];

      importConfigFile =
        rootDir:
        if (builtins.pathExists (rootDir + /+config.nix)) then [ (rootDir + /+config.nix) ] else [ ];

      importModuleFile =
        rootDir:
        if (builtins.pathExists (rootDir + /+module.nix)) then [ (rootDir + /+module.nix) ] else [ ];

      commonImports = rootDir: (importCommonFile rootDir) ++ (importCommonDir rootDir);

      homeImports =
        rootDir:
        (importHomeFile rootDir)
        ++ (importHomeDir rootDir)
        ++ (importModuleFile rootDir)
        ++ (importConfigFile rootDir)
        ++ lib.optionals homeMarker (commonImports rootDir);
      systemImports =
        rootDir:
        (importSystemFile rootDir)
        ++ (importSystemDir rootDir)
        ++ (importModuleFile rootDir)
        ++ (importConfigFile rootDir)
        ++ (commonImports rootDir);

      moduleAll =
        rootDir:
        builtins.filter (path: builtins.pathExists path) (
          map (f: rootDir + "/${f}") (
            builtins.attrNames (
              removeAttrs (builtins.readDir rootDir) [
                "default.nix"
                "+home.nix"
                "+system.nix"
                "+module.nix"
                "+config.nix"
                "+common.nix"
                "+extras"
                "+extras.nix"
              ]
            )
          )
        );
    in
    {
      default =
        rootDir:
        if isDroid then
          {
            imports = importModuleFile rootDir;
            home-manager.config = {
              imports = homeImports rootDir;
            };
          }
        else if (!isGeneric && !homeMarker) then
          {
            imports = systemImports rootDir;
            home-manager.users.${username} = {
              imports = homeImports rootDir;
            };
          }
        else
          {
            imports = homeImports rootDir;
          };
      all = rootDir: { imports = moduleAll rootDir; };
    };

}

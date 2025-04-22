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
with lib;
rec {
  match = flip getAttr;
  read_dir_recursively =
    dir:
    concatMapAttrs (
      this:
      match {
        directory = mapAttrs' (subpath: nameValuePair "${this}/${subpath}") (
          read_dir_recursively "${dir}/${this}"
        );
        regular = {
          ${this} = "${dir}/${this}";
        };
        symlink = { };
      }
    ) (builtins.readDir dir);

  # `const` helper function is used extensively: the function is constant in regards to the name of the attribute.

  params = inputs // {
    configs = raw_configs;
    inherit merge extras;
  };

  # It is important to note, that when adding a new `.mod.nix` file, you need to run `git add` on the file.
  # If you don't, the file will not be included in the flake, and the modules defined within will not be loaded.

  read_all_modules = flip pipe [
    read_dir_recursively
    (filterAttrs (flip (const (hasSuffix ".mod.nix"))))
    (mapAttrs (const import))
    (mapAttrs (const (flip toFunction params)))
  ];

  merge =
    prev: this:
    {
      modules = prev.modules or [ ] ++ this.modules or [ ];
      home_modules = prev.home_modules or [ ] ++ this.home_modules or [ ];
    }
    // (optionalAttrs (prev ? system || this ? system) {
      system = prev.system or this.system;
    });

  all_modules = attrValues (read_all_modules "${self}");

  raw_configs' = builtins.zipAttrsWith (
    machine: if machine == "extras" then mergeAttrsList else builtins.foldl' merge { }
  ) all_modules;

  raw_configs = builtins.removeAttrs raw_configs' [ "extras" ];

  extras = raw_configs'.extras or { };

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

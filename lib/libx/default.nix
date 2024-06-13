{
  inputs,
  homeDirectory ? "~",
  username,
  isGeneric,
}: let
  inherit (inputs.nixpkgs) lib;
in rec {
  inherit (import ../../packages/args.nix) clj;
  corePackages = pkgs: import ../../packages/corePackages.nix {inherit pkgs;};
  nixpkgsConfig = import ./nixpkgsConfig.nix;
  colors = (import ./colors.nix) // inputs.nix-colors.lib;
  fonts = import ./fonts.nix;
  wallpaper = "${homeDirectory}/.local/share/backgrounds/nice-mountain.jpg";
  sway = import ./sway.nix {inherit lib;};
  toRasi = import ./toRasi.nix {inherit lib;};
  mkLiteral = value: {
    _type = "literal";
    inherit value;
  };
  getModules = {
    cfg ? null,
    subCfg ? null,
    modules,
  }: let
    ifSubCfg = module:
      if (subCfg == null && cfg != null)
      then cfg.${lib.removeSuffix ".nix" (builtins.baseNameOf module)}.enable
      else subCfg;
  in
    builtins.filter ifSubCfg modules;

  importModules = {
    modules,
    cfg,
    rootDir ? null,
    fileName ? "persist",
  }:
    if isGeneric
    then {
      imports = getModules {inherit modules cfg;};
    }
    else {
      imports = lib.optionals (rootDir != null) (scanDirs {
        inherit fileName rootDir;
      });
      config.home-manager.users.${username} = {...}: {
        imports = getModules {inherit modules cfg;};
      };
    };

  enableModules = modules:
    builtins.listToAttrs (map (module: {
        name = lib.removeSuffix ".nix" (builtins.baseNameOf module);
        value = {enable = true;};
      })
      modules);

  scanDirs = {
    fileName,
    rootDir,
  }:
    builtins.filter (path: builtins.pathExists path) (map (dir: ./${dir}/${fileName}.nix)
      (builtins.attrNames (removeAttrs rootDir ["default.nix"])));

  mkPathList = dir: builtins.attrNames (removeAttrs (builtins.readDir dir) ["default.nix" "home.nix"]);

  gtkPackage = pkgs:
    pkgs.colloid-gtk-theme.overrideAttrs (_: {
      src = pkgs.fetchFromGitHub {
        owner = "vinceliuice";
        repo = "Colloid-gtk-theme";
        rev = "c572621db69ec4f9a023d883d1b82a4d559ffab5";
        hash = "sha256-+YzZ+RqqIOSj7rxavBdcROQ0fyeG5I1c54vapJjwcbg=";
      };

      installPhase = ''
        runHook preInstall
        # override colors
        sed -i "s\window-radius: 12px\window-radius: 5px\g" ./src/sass/_variables.scss

        sed -i "s\#0d0e11\#${colors.default.background}\g" ./src/sass/_color-palette-nord.scss
        sed -i "s\#bf616a\#${colors.bright.red}\g" ./src/sass/_color-palette-nord.scss
        sed -i "s\#a3be8c\#${colors.normal.magenta}\g" ./src/sass/_color-palette-nord.scss
        sed -i "s\#ebcb8b\#${colors.bright.yellow}\g" ./src/sass/_color-palette-nord.scss
        sed -i "s\#3a4150\#${colors.extra.azure}\g" ./src/sass/_color-palette-nord.scss
        sed -i "s\#333a47\#${colors.extra.nocturne}\g" ./src/sass/_color-palette-nord.scss
        sed -i "s\#242932\#${colors.extra.nocturne}\g" ./src/sass/_color-palette-nord.scss
        sed -i "s\#1e222a\#${colors.extra.obsidian}\g" ./src/sass/_color-palette-nord.scss
        name= HOME="$TMPDIR" ./install.sh \
          --color dark \
          --tweaks rimless nord \
          --dest $out/share/themes
        jdupes --quiet --link-soft --recurse $out/share
        runHook postInstall
      '';
    });
  cursorTheme = {
    name = "phinger-cursors-light";
    package = pkgs: pkgs.phinger-cursors;
    x-scaling = 1.0;
    size = 32;
  };

  iconTheme = {
    name = "Papirus-Dark";
    package = pkgs:
      pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "lavender";
      };
  };

  gtkTheme = {
    name = "Colloid-Dark-Nord";
    package = gtkPackage;
  };

  gnomeShellTheme = {
    name = "Colloid-Dark-Nord";
    package = gtkPackage;
  };
}

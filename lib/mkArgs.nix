{
  self,
  inputs,
  outputs,
  defaultUser,
  stateVersion,
  profile,
  desktop ? null,
  is_iso ? false,
  is_generic_linux ? false,
  is_laptop,
}: rec {
  inherit (inputs.nixpkgs) lib;

  username =
    if is_iso
    then "nixos"
    else defaultUser;

  scrt = builtins.fromJSON (builtins.readFile "${self}/lib/secrets/token.json");

  homeDirectory = "/home/${username}";

  flakeDirectory = "${homeDirectory}/nix-dots";

  ui = {
    colors =
      (import ./ui/colors.nix)
      // inputs.nix-colors.lib;
    fonts = import ./ui/fonts.nix;
    wallpaper = "${homeDirectory}/.local/share/backgrounds/nasa-earth.jpg";
  };
  ifPathExists = path:
    lib.optionals (builtins.pathExists path) [path];

  ifPathExist = path:
    lib.optional (builtins.pathExists path) path;

  listImports = path: modules:
    lib.forEach modules (mod: path + "/${mod}");

  listSystemImports = modules:
    lib.forEach modules (mod: "${self}/system/${mod}");

  listHomeImports = modules:
    lib.forEach modules (mod: "${self}/home/${mod}");

  hostName = profile;

  args =
    {
      inherit
        self
        inputs
        outputs
        homeDirectory
        username
        hostName
        scrt
        ui
        ifPathExists
        ifPathExist
        desktop
        listImports
        listHomeImports
        listSystemImports
        flakeDirectory
        stateVersion
        is_generic_linux
        is_laptop
        is_iso
        ;
    }
    // lib.optionalAttrs is_iso {target_user = defaultUser;};
}

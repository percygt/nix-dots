{
  self,
  inputs,
  outputs,
  username,
  defaultUser,
  stateVersion,
  profile,
  desktop ? null,
  is_iso ? false,
  is_generic_linux ? false,
  is_laptop ? false,
}: rec {
  inherit (inputs.nixpkgs) lib;
  inherit username;
  homeDirectory = "/home/${username}";

  flakeDirectory = "${homeDirectory}/nix-dots";

  ui = {
    colors =
      (import ./ui/colors.nix)
      // inputs.nix-colors.lib;
    fonts = import ./ui/fonts.nix;
    wallpaper = "${homeDirectory}/.local/share/backgrounds/building-top.jpg";
  };
  ifPathExists = path:
    lib.optionals (builtins.pathExists path) [path];

  ifPathExist = path:
    lib.optional (builtins.pathExists path) path;

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
        ui
        ifPathExists
        ifPathExist
        desktop
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

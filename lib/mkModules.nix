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

  homeDirectory = "/home/${username}";

  flakeDirectory = "${homeDirectory}/nix-dots";

  colors = import ./colors.nix;

  ui = {
    colors =
      (import ./ui/colors)
      // inputs.nix-colors.lib;
    fonts = import ./ui/fonts.nix;
    wallpaper = "${homeDirectory}/.local/share/backgrounds/nasa-earth.jpg";
  };

  listImports = path: modules:
    lib.forEach modules (mod: path + "/${mod}");

  listHomeImports = modules:
    lib.forEach modules (mod: "${self}/home" + "/${mod}");

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
        desktop
        colors
        listImports
        flakeDirectory
        stateVersion
        is_generic_linux
        is_laptop
        ;
    }
    // lib.optionalAttrs is_iso {target_user = defaultUser;};

  homeModules = [
    ../profiles/${profile}/home.nix
  ];

  nixosModules = [
    ../profiles/${profile}/configuration.nix
    # {
    #   home-manager = {
    #     useGlobalPkgs = true;
    #     useUserPackages = true;
    #     users.${username} = {
    #       imports = homeModules;
    #     };
    #     extraSpecialArgs = args;
    #   };
    # }
  ];
}

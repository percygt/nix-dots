{
  self,
  inputs,
  outputs,
  username,
  defaultUser,
  stateVersion,
  profile,
  desktop ? null,
  useIso ? false,
  useGenericLinux ? false,
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
    wallpaper = "${homeDirectory}/.local/share/backgrounds/nice-mountain.jpg";
  };

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
        flakeDirectory
        stateVersion
        useGenericLinux
        useIso
        ;
    }
    // lib.optionalAttrs useIso {target_user = defaultUser;};
}

{
  self,
  inputs,
  outputs,
  user,
  defaultUser,
  stateVersion,
  profile,
  isGeneric ? false,
  desktop ? null,
  useIso ? false,
}: rec {
  inherit (inputs.nixpkgs) lib;

  username =
    if useIso
    then "nixos"
    else user;

  homeDirectory = "/home/${username}";

  flakeDirectory = "${homeDirectory}/nix-dots";

  ui = {
    colors =
      (import ./ui/colors.nix)
      // inputs.nix-colors.lib;
    fonts = import ./ui/fonts.nix;
    wallpaper = "${homeDirectory}/.local/share/backgrounds/nice-mountain.jpg";
  };

  args =
    {
      inherit
        self
        inputs
        outputs
        homeDirectory
        username
        profile
        ui
        isGeneric
        desktop
        flakeDirectory
        stateVersion
        useIso
        ;
    }
    // lib.optionalAttrs useIso {target_user = defaultUser;};
}

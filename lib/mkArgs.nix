{
  self,
  inputs,
  outputs,
  username,
  stateVersion,
  profile,
  isGeneric ? false,
  desktop ? null,
  useIso ? false,
}: rec {
  inherit (inputs.nixpkgs) lib;

  users =
    if useIso
    then {
      targetUser = username;
      username = "nixos";
    }
    else {inherit username;};

  homeDirectory = "/home/${users.username}";

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
        profile
        ui
        isGeneric
        desktop
        flakeDirectory
        stateVersion
        useIso
        ;
    }
    // users;
}

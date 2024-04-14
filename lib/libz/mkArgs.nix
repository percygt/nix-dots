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

  libx = import "${self}/lib/libx" {inherit inputs homeDirectory;};

  args =
    {
      inherit
        self
        inputs
        outputs
        homeDirectory
        profile
        libx
        isGeneric
        desktop
        flakeDirectory
        stateVersion
        useIso
        ;
    }
    // users;
}

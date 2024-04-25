{
  self,
  inputs,
  outputs,
  username,
  stateVersion,
  profile,
  isGeneric ? false,
  desktop ? null,
  isIso ? false,
}: rec {
  inherit (inputs.nixpkgs) lib;

  users =
    if isIso
    then {
      targetUser = username;
      username = "nixos";
    }
    else {inherit username;};

  homeDirectory = "/home/${users.username}";

  flakeDirectory = "${homeDirectory}/data/nix-dots";

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
        isIso
        ;
    }
    // users;
}

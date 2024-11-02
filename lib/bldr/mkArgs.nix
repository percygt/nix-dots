{
  self,
  inputs,
  outputs,
  profile,
  isGeneric ? false,
  desktop ? null,
  isIso ? false,
  homeMarker ? false,
  stateVersion,
  username,
}:
rec {

  libx = import "${self}/lib/libx" {
    inherit
      inputs
      isGeneric
      isIso
      username
      homeMarker
      ;
  };

  homeDirectory = "/home/${username}";

  args = {
    inherit
      self
      inputs
      outputs
      profile
      username
      libx
      isGeneric
      homeDirectory
      stateVersion
      desktop
      isIso
      homeMarker
      ;
  };
}

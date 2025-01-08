{
  self,
  inputs,
  outputs,
  isDroid ? false,
  profile ? null,
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
      username
      homeMarker
      isDroid
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
      isDroid
      isGeneric
      homeDirectory
      stateVersion
      desktop
      isIso
      homeMarker
      ;
  };
}

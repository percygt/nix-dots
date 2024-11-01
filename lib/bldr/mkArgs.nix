{
  self,
  inputs,
  outputs,
  profile,
  isGeneric ? false,
  desktop ? null,
  isIso ? false,
  homeMarker ? false,
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

  args = {
    inherit
      self
      inputs
      outputs
      profile
      libx
      isGeneric
      desktop
      isIso
      homeMarker
      ;
  };
}

{
  self,
  inputs,
  outputs,
  profile,
  isGeneric ? false,
  desktop ? null,
  isIso ? false,
  username,
  buildMarker,
}:
rec {

  libx = import "${self}/lib/libx" {
    inherit
      inputs
      isGeneric
      isIso
      username
      buildMarker
      ;
  };

  args = {
    inherit
      buildMarker
      self
      inputs
      outputs
      profile
      libx
      isGeneric
      desktop
      isIso
      ;
  };
}

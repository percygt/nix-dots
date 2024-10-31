{
  self,
  inputs,
  outputs,
  profile,
  isGeneric ? false,
  desktop ? null,
  isIso ? false,
  username,
  buildHome,
}:
rec {

  libx = import "${self}/lib/libx" {
    inherit
      inputs
      isGeneric
      isIso
      username
      buildHome
      ;
  };

  args = {
    inherit
      buildHome
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

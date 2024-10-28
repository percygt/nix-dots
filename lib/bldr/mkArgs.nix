{
  self,
  inputs,
  outputs,
  profile,
  isGeneric ? false,
  desktop ? null,
  isIso ? false,
  bldr,
}:
rec {

  libx = import "${self}/lib/libx" { inherit inputs isGeneric isIso; };

  args = {
    inherit
      bldr
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

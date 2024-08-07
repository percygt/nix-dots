{
  self,
  inputs,
  outputs,
  profile,
  isGeneric ? false,
  desktop ? null,
  isIso,
}:
rec {

  libx = import "${self}/lib/libx" { inherit inputs isGeneric isIso; };

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
      ;
  };
}

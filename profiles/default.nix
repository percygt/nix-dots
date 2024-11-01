{
  profile,
  isGeneric,
  isIso,
  lib,
  ...
}:
{
  imports = [
    ./common
    (if isIso then ./isos/${profile} else ./systems/${profile})
  ];
}

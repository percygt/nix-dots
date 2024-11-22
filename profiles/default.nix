{
  profile,
  isIso,
  lib,
  ...
}:
{
  imports = lib.optionals (profile != null) [
    (if isIso then ./isos/${profile} else ./systems/${profile})
  ];
}

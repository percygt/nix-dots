{ profile, isIso, ... }:
{
  imports = [
    (if isIso then ./isos/${profile} else ./systems/${profile})
  ];
}

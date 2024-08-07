{ profile, isIso, ... }:
{
  imports = [
    ./common
    (if isIso then ./isos/${profile} else ./systems/${profile})
  ];
}

{
  lib,
  useIso,
  ...
}: {
  imports = lib.optionals useIso [
    ./installer.nix
  ];
}

{
  lib,
  isGeneric,
  ...
}: {
  imports =
    [
      ./cli
      ./desktop
      ./editor
      ./bin
      ./terminal
      ./shell
      ./infosec
      ./dev
      ./browser
      ./common
      ./gui/common.nix
    ]
    ++ lib.optionals isGeneric [./generic];
}

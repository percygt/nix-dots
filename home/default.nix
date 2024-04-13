{
  lib,
  desktop,
  inputs,
  isGeneric,
  outputs,
  ...
}: {
  imports =
    [
      ./common
      ./cli
      ./desktop
      ./editor
      ./bin
      ./terminal
      ./shell
      ./infosec
      ./dev
      # ./backup
    ]
    ++ lib.optionals isGeneric [
      ./generic
    ];

  nixpkgs.overlays = builtins.attrValues outputs.overlays;
}

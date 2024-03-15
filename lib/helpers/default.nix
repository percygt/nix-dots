{lib, ...}: {
  inherit
    (import ./colorTools.nix {inherit lib;})
    x
    xToRgb
    hexToRgb
    ;
}

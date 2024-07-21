{ inputs }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  inherit (import ../../packages/args.nix) clj;
  sway = import ./sway.nix { inherit lib; };
  toRasi = import ./toRasi.nix { inherit lib; };
  mkLiteral = value: {
    _type = "literal";
    inherit value;
  };
  colorConvert = import ./colorCoversions.nix { nixpkgs-lib = lib; };
}

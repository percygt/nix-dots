{ inputs }:
let
  inherit (inputs.nixpkgs) lib;
in
rec {
  inherit (import ../../packages/args.nix) clj;
  sway = import ./sway.nix { inherit lib; };
  toRasi = import ./toRasi.nix { inherit lib; };
  mkLiteral = value: {
    _type = "literal";
    inherit value;
  };

}

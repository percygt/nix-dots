{
  lib,
  inputs,
}:
let
  inherit (builtins) filter map toString;
  inherit (lib) pipe;
  inherit (lib.lists) flatten forEach;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix hasPrefix;
in
rec {
  sway = import ./sway.nix { inherit lib; };
  importHomeModules =
    rootDir:
    pipe rootDir [
      listFilesRecursive
      (map toString)
      (filter (n: !hasPrefix "." (baseNameOf n)))
      (filter (n: !hasPrefix "__" (baseNameOf n)))
      (filter (n: (hasSuffix ".hm.nix" n) || (hasSuffix ".c.nix" n) || (hasSuffix "_options.nix" n)))
    ];
  importHomeForEachDir = dirs: (flatten (forEach dirs importHomeModules));
  importNixosModules =
    rootDir:
    pipe rootDir [
      listFilesRecursive
      (map toString)
      (filter (hasSuffix ".nix"))
      (filter (n: (!hasSuffix "default.nix" n) || (!hasSuffix "flake.nix" n)))
      (filter (n: !hasPrefix "." (baseNameOf n)))
      (filter (n: !hasPrefix "__" (baseNameOf n)))
      (filter (n: !hasSuffix ".hm.nix" n))
    ];
  importNixosForEachDir = dirs: (flatten (forEach dirs importNixosModules));
  colorConvert = import ./colorCoversions.nix { nixpkgs-lib = lib; } // {
    hex = {

    };
  };
}

{
  lib,
  desktop,
  self,
  outputs,
  inputs,
  ...
}:
{
  nixpkgs.overlays = builtins.attrValues outputs.overlays;
  # ++ lib.optionals (desktop == "sway") (
  #   builtins.attrValues (import "${self}/overlays/sway.nix" { inherit inputs; })
  # );
}

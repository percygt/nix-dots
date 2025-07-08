{
  outputs,
  ...
}:
{
  nixpkgs.overlays = builtins.attrValues outputs.overlays;
}

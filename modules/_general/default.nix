{ inputs, libx, ... }:
{
  imports = [ (builtins.toString inputs.general) ] ++ libx.importPaths.moduleDefault ./.;
}

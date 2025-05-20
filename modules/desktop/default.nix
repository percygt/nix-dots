{ desktop, ... }:
if (builtins.pathExists ./${desktop}) then
  {
    imports = [ ./${desktop} ];
  }
else
  { }

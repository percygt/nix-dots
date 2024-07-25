{ lib, ... }:
{
  options.modules.dev.enable = lib.mkEnableOption "Enable devtools";
}

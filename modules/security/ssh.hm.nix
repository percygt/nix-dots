{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.security.ssh;
in
{
  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      inherit (cfg) package;
    };
  };
}

{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.generic.xremap;
in
{
  imports = [ inputs.xremap.homeManagerModules.default ];

  options = {
    generic.xremap = {
      enable = lib.mkEnableOption "Enable xremap";
      withGnome = lib.mkEnableOption "Enable xremap withGnome";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xremap = {
      withGnome = lib.mkIf cfg.withGnome true;
      config.modmap = [
        {
          name = "Global";
          remap = {
            "CAPSLOCK" = {
              held = [ "CONTROL_L" ];
              alone = [ "ESC" ];
              alone_timeout_millis = 150;
            };
          };
        }
      ];
    };
    home = {
      activation.setupXremap = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        /usr/bin/systemctl start --user xremap
      '';
    };
  };
}

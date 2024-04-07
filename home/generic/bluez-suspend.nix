{
  lib,
  config,
  ...
}: {
  options = {
    generic.bluez-suspend = {
      disable =
        lib.mkEnableOption "Disable bluez suspend";
    };
  };

  config = lib.mkIf config.generic.bluez-suspend.disable {
    xdg.configFile."wireplumber/bluetooth.lua.d/50-bluez-config.lua".text = ''
      bluez_monitor.enabled = true
      bluez_monitor.properties = {
        ["with-logind"] = true,
      }
      bluez_monitor.rules = {
        {
          matches = {
            {
              { "device.name", "matches", "bluez_card.*" },
            },
          },
          apply_properties = {
          },
        },
        {
          matches = {
            {
              { "node.name", "matches", "bluez_input.*" },
            },
            {
              { "node.name", "matches", "bluez_output.*" },
            },
          },
          apply_properties = {
            ["session.suspend-timeout-seconds"] = 0,  -- 0 disables suspend
          },
        },
      }
    '';
  };
}

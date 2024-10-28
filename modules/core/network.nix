{
  lib,
  config,
  libx,
  ...
}:
let
  g = config._general;
  wpa = config.modules.core.network.wpa.enable;
  cfg = config.modules.core.network;
  networkApplet =
    if wpa then
      "exec $toggle_window --id wpa_gui -- wpa_gui"
    else
      "exec $toggle_window --id nm-connection-editor -- nm-connection-editor";

in
{
  options.modules.core.network = {
    enable = libx.enableDefault "network";
    wpa.enable = lib.mkOption {
      description = "Enable wpa";
      type = lib.types.bool;
      default = !cfg.enable;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      { sops.secrets."wireless.env".neededForUsers = true; }
      (lib.mkIf config.programs.sway.enable {
        home-manager.users.${g.username} = {
          imports = [
            (
              { config, ... }:
              let
                cfg = config.wayland.windowManager.sway.config;
                mod = cfg.modifier;
              in
              {
                wayland.windowManager.sway.config.keybindings = {
                  "${mod}+n" = networkApplet;
                };
              }
            )
          ];
        };
      })
      (lib.mkIf wpa {
        users.groups.network = { };
        users.users.${g.username}.extraGroups = [ "network" ];
        services.avahi.enable = lib.mkForce false;
        systemd.services.wpa_supplicant = {
          preStart = lib.mkIf wpa "touch /etc/wpa_supplicant.conf";
          serviceConfig.TimeoutSec = "10";
        };
        networking = {
          networkmanager.enable = lib.mkForce false;
          wireless = {
            enable = true;
            secretsFile = config.sops.secrets."wireless.env".path;
            networks = {
              "${g.network.wifi}" = {
                hidden = true;
                psk = "ext:home_psk";
              };
            };
            # Imperative
            allowAuxiliaryImperativeNetworks = true;
            userControlled = {
              enable = true;
              group = "network";
            };
            extraConfig = ''
              update_config=1
            '';
          };
        };
      })
      (lib.mkIf (!wpa) {
        systemd = {
          services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ]; # Normally ["network-online.target"]
          targets.network-online.wantedBy = lib.mkForce [ ]; # Normally ["multi-user.target"]
        };
        programs.nm-applet = {
          enable = true;
          indicator = true;
        };
        environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
          "/persist/system" = {
            directories = [ "/etc/NetworkManager/system-connections" ];
          };
        };
        networking = {
          wireless.iwd.settings.Settings.AutoConnect = true;
          networkmanager = {
            enable = true;
            wifi.backend = "iwd";
          };
        };
      })
    ]
  );
}

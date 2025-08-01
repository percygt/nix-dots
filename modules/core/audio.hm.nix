{
  lib,
  config,
  pkgs,
  ...
}:
let
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
  inherit (pkgs) rnnoise-plugin;
in
{
  config = lib.mkIf config.modules.core.audio.enable {
    wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
      "${mod}+v" =
        "exec ddapp -t 'volume' -h 50 -w 50 -- 'footclient --title=VolumeControl --app-id=volume -- ncpamixer'";
    };
    home.packages = with pkgs; [
      ncpamixer # Terminal mixer for PulseAudio inspired by pavucontrol
    ];

    services.mpris-proxy.enable = true;
    xdg.configFile."pipewire/pipewire.conf.d/99-rnnoise.conf" = {
      text = builtins.toJSON {
        "context.properties" = {
          "link.max-buffers" = 16;
          "core.daemon" = true;
          "core.name" = "pipewire-0";
          "module.x11.bell" = false;
          "module.access" = true;
          "module.jackdbus-detect" = false;
        };

        "context.modules" = [
          {
            name = "libpipewire-module-filter-chain";
            args = {
              "node.description" = "Noise Canceling source";
              "media.name" = "Noise Canceling source";

              "filter.graph" = {
                nodes = [
                  {
                    type = "ladspa";
                    name = "rnnoise";
                    plugin = "${rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                    label = "noise_suppressor_mono";
                    control = {
                      "VAD Threshold (%)" = 80.0;
                      "VAD Grace Period (ms)" = 200;
                      "Retroactive VAD Grace (ms)" = 0;
                    };
                  }
                ];
              };

              "capture.props" = {
                "node.name" = "capture.rnnoise_source";
                "node.passive" = true;
                "audio.rate" = 48000;
              };

              "playback.props" = {
                "node.name" = "rnnoise_source";
                "media.class" = "Audio/Source";
                "audio.rate" = 48000;
              };
            };
          }
        ];
      };
    };
  };
}

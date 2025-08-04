{
  config,
  pkgs,
  inputs,
  homeDirectory,
  ...
}:
let
  cfg = config.modules.desktop.sway;
  g = config._base;
  a = config.modules.themes.assets;
  f = config.modules.fonts.app;
  c = config.modules.themes.colors.withHashtag;
  inherit (config.modules.themes)
    cursorTheme
    iconTheme
    gtkTheme
    ;
in
{
  programs.niri = {
    settings = {
      environment = {
        CLUTTER_BACKEND = "wayland";
        DISPLAY = null;
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        _JAVA_AWT_WM_NONREPARENTING = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        SDL_VIDEODRIVER = "wayland";
      };
      workspaces = {
        main = {
          open-on-output = "HDMI-A-1";
        };
        scratchpad = {

          open-on-output = "HDMI-A-1";
        };
      };
      spawn-at-startup = [
        { command = [ "waybar" ]; }
        # { command = [ "hyprlock" ]; }
        {
          command = [
            "foot"
            "--server"
          ];
        }
        {
          command = [
            "tmux"
            "start-server"
          ];
        }
      ];
      input = {
        keyboard.xkb.layout = "us";

        touchpad = {
          tap = true;
          dwt = true;
          dwtp = true;
          click-method = "button-areas";
          natural-scroll = true;
          scroll-method = "two-finger";
          tap-button-map = "left-right-middle";
          middle-emulation = true;
          accel-profile = "adaptive";
        };
        mouse = {
          accel-speed = 0.1;
        };
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "0%";
        };
        warp-mouse-to-focus.enable = true;
        workspace-auto-back-and-forth = true;
      };
      screenshot-path = homeDirectory + "/pictures/screenshot";
      outputs = {
        "eDP-1" = {
          scale = 1.0;
          position = {
            x = 0;
            y = 0;
          };
        };
        "HDMI-A-1" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = null;
          };
          scale = 1.0;
          position = {
            x = 1920;
            y = 0;
          };
        };
      };

      overview = {
        workspace-shadow.enable = false;
        backdrop-color = "transparent";
      };
      gestures = {
        hot-corners.enable = true;
      };
      cursor = {
        inherit (cursorTheme) size;
        theme = "${cursorTheme.name}";
      };
      layout = {
        focus-ring.enable = false;
        border = {
          enable = true;
          width = 4;
          active.color = "#ED61D730";
          inactive.color = "#B8149F30";
        };
        shadow = {
          enable = true;
        };
        preset-column-widths = [
          { proportion = 0.25; }
          { proportion = 0.5; }
          { proportion = 0.75; }
          { proportion = 1.0; }
        ];
        default-column-width = {
          proportion = 0.8;
        };

        gaps = 6;
        struts = {
          left = 0;
          right = 0;
          top = 0;
          bottom = 0;
        };

        tab-indicator = {
          hide-when-single-tab = true;
          place-within-column = true;
          position = "left";
          corner-radius = 20.0;
          gap = -12.0;
          gaps-between-tabs = 10.0;
          width = 4.0;
          length.total-proportion = 0.1;
        };
      };
      animations = {
        horizontal-view-movement.kind.spring = {
          damping-ratio = 1.0;
          stiffness = 300;
          epsilon = 0.00001;
        };
        window-movement.kind.spring = {
          damping-ratio = 1.0;
          stiffness = 200;
          epsilon = 0.00001;
        };
        workspace-switch.kind.spring = {
          damping-ratio = 0.8;
          stiffness = 200;
          epsilon = 0.0001;
        };
        window-open = {
          kind.easing = {
            duration-ms = 400;
            curve = "ease-out-cubic";
          };
          custom-shader = ''
            float map(float value, float min1, float max1, float min2, float max2) {
                return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
            }

            vec4 open_color(vec3 coords_geo, vec3 size_geo) {
                float cur = niri_clamped_progress;
                vec3 coord = vec3(
                    coords_geo.x,
                    map(coords_geo.y, 0.0, cur, 0.0, 1.0),
                    coords_geo.z
                );
                coord.y += 1.0 * (1.0 - cur);
                return texture2D(niri_tex, (niri_geo_to_tex * coord).st);
            }
          '';
        };
        window-close = {
          kind.easing = {
            duration-ms = 400;
            curve = "ease-out-cubic";
          };
          custom-shader = ''
            float map(float value, float min1, float max1, float min2, float max2) {
                return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
            }

            vec4 open_color(vec3 coords_geo, vec3 size_geo) {
                float cur = niri_clamped_progress;
                vec3 coord = vec3(
                    coords_geo.x,
                    map(coords_geo.y, 0.0, cur, 0.0, 1.0),
                    coords_geo.z
                );
                coord.y += 1.0 * (1.0 - cur);
                return texture2D(niri_tex, (niri_geo_to_tex * coord).st);
            }
          '';
        };
        window-resize.custom-shader = ''
          vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
            vec3 coords_next_geo = niri_curr_geo_to_next_geo * coords_curr_geo;

            vec3 coords_stretch = niri_geo_to_tex_next * coords_curr_geo;
            vec3 coords_crop = niri_geo_to_tex_next * coords_next_geo;

            // We can crop if the current window size is smaller than the next window
            // size. One way to tell is by comparing to 1.0 the X and Y scaling
            // coefficients in the current-to-next transformation matrix.
            bool can_crop_by_x = niri_curr_geo_to_next_geo[0][0] <= 1.0;
            bool can_crop_by_y = niri_curr_geo_to_next_geo[1][1] <= 1.0;

            vec3 coords = coords_stretch;
            if (can_crop_by_x)
                coords.x = coords_crop.x;
            if (can_crop_by_y)
                coords.y = coords_crop.y;

            vec4 color = texture2D(niri_tex_next, coords.st);

            // However, when we crop, we also want to crop out anything outside the
            // current geometry. This is because the area of the shader is unspecified
            // and usually bigger than the current geometry, so if we don't fill pixels
            // outside with transparency, the texture will leak out.
            //
            // When stretching, this is not an issue because the area outside will
            // correspond to client-side decoration shadows, which are already supposed
            // to be outside.
            if (can_crop_by_x && (coords_curr_geo.x < 0.0 || 1.0 < coords_curr_geo.x))
                color = vec4(0.0);
            if (can_crop_by_y && (coords_curr_geo.y < 0.0 || 1.0 < coords_curr_geo.y))
                color = vec4(0.0);

            return color;
          }
        '';
      };
      prefer-no-csd = true;
      hotkey-overlay.skip-at-startup = true;
    };
  };
  # xdg.configFile = {
  #   "niri/config.kdl".source =
  #     config.lib.file.mkOutOfStoreSymlink "${g.flakeDirectory}/desktop/niri/config.kdl";
  # };
}

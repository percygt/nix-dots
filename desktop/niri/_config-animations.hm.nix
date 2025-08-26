{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  cfg = config.modules.desktop.niri;
  g = config._base;
  a = config.modules.themes.assets;
  f = config.modules.fonts.app;
  c = config.modules.themes.colors.withHashtag;
in
{
  programs.niri.settings.animations = {
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
        duration-ms = 200;
        curve = "ease-out-quad";
      };
      custom-shader = ''
        float map(float value, float min1, float max1, float min2, float max2) {
            return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
        }

        vec4 open_color(vec3 coords_geo, vec3 size_geo) {
            float cur = niri_clamped_progress;
            if (coords_geo.x > cur) {
                return vec4(0.0);
            }
            vec3 coord = vec3(map(coords_geo.x,0.0, cur, 0.0, 1.0 ), coords_geo.y, coords_geo.z);
            return texture2D(niri_tex, (niri_geo_to_tex * coord).st);
        }
      '';
    };
    window-close = {
      kind.easing = {
        duration-ms = 200;
        curve = "ease-out-quad";
      };
      custom-shader = ''
        float map(float value, float min1, float max1, float min2, float max2) {
            return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
        }
        vec4 close_color(vec3 coords_geo, vec3 size_geo) {
            float cur = 1.0-niri_clamped_progress;
            if (coords_geo.x > cur) {
                return vec4(0.0);
            }
            vec3 coord = vec3(map(coords_geo.x,0.0, cur, 0.0, 1.0), coords_geo.y, coords_geo.z);
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
}

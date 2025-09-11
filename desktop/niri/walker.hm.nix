{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  walkerConfig = {
    app_launch_prefix = "systemd-run --user ";
    ui = {
      anchors = {
        bottom = true;
        left = true;
        right = true;
        top = true;
      };
      window = {
        box = {
          bar = {
            entry = {
              h_align = "fill";
              h_expand = true;
              icon = {
                h_align = "center";
                h_expand = true;
                pixel_size = 24;
                theme = "";
              };
            };
            orientation = "horizontal";
            position = "end";
          };
          h_align = "center";
          v_align = "center";
          margins = {
            top = 8;
          };
          scroll = {
            list = {
              grid = true;
              item = {
                margins = {
                  top = 0;
                  bottom = 0;
                  left = 0;
                  right = 0;
                };
                height = 100;
                max_height = 100;
                orientation = "vertical";
                activation_label = {
                  hide = true;
                };
                icon = {
                  pixel_size = 100;
                  height = 40;
                  theme = "";
                };
                label = {
                  h_align = "center";
                  hide = true;
                };
              };
              margins = {
                top = 0;
                bottom = 0;
                left = 0;
                right = 0;
              };
              max_height = 495;
              max_width = 800;
              min_width = 800;
              width = 150;
            };
          };
          search = {
            clear = {
              h_align = "center";
              icon = "edit-clear";
              name = "clear";
              pixel_size = 18;
              theme = "";
              v_align = "center";
            };
            input = {
              h_align = "fill";
              h_expand = true;
              icons = true;
              icon = "";
            };
            prompt = {
              h_align = "center";
              icon = "edit-find";
              name = "prompt";
              pixel_size = 18;
              theme = "";
              v_align = "center";
            };
            spinner = {
              hide = true;
            };
          };
          width = 250;
        };
        h_align = "fill";
        v_align = "fill";
      };
    };
    plugins = [
      {
        keep_sort = true;
        name = "power";
        placeholder = "Power";
        recalculate_score = true;
        show_icon_when_single = true;
        switcher_only = true;
        entries = [
          {
            exec = "playerctl --all-players pause & hyprlock";
            icon = "system-lock-screen";
            label = "Lock Screen";
          }
          {
            exec = "niri exit";
            icon = "system-logout";
            label = "Logout";
          }
          {
            exec = "loginctl lock-session; sleep 1; systemctl suspend";
            icon = "system-suspend";
            label = "Suspend";
          }
          {
            exec = "shutdown now";
            icon = "system-shutdown";
            label = "Shutdown";
          }
          {
            exec = "reboot";
            icon = "system-reboot";
            label = "Reboot";
          }
        ];
      }
    ];
  };
in
{
  imports = [ inputs.walker.homeManagerModules.default ];
  programs.walker = {
    enable = true;
    runAsService = true;

    config = walkerConfig;
  };

  home.packages = [ pkgs.iwmenu ];

}

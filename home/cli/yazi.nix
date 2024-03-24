{
  lib,
  config,
  ...
}: {
  options = {
    cli.yazi.enable =
      lib.mkEnableOption "Enable yazi";
  };

  config = lib.mkIf config.cli.yazi.enable {
    home.shellAliases.y = "yazi";
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      # keymap = {
      #   input.keymap = [
      #     {
      #       exec = "close";
      #       on = ["<c-q>"];
      #     }
      #     {
      #       exec = "close --submit";
      #       on = ["<enter>"];
      #     }
      #     {
      #       exec = "escape";
      #       on = ["<esc>"];
      #     }
      #     {
      #       exec = "backspace";
      #       on = ["<backspace>"];
      #     }
      #   ];
      #   manager.keymap = [
      #     {
      #       exec = "escape";
      #       on = ["<esc>"];
      #     }
      #     {
      #       exec = "quit";
      #       on = ["q"];
      #     }
      #     {
      #       exec = "close";
      #       on = ["<c-q>"];
      #     }
      #   ];
      # };
      theme = {
        filetype = {
          rules = [
            {
              fg = "#7AD9E5";
              mime = "image/*";
            }
            {
              fg = "#F3D398";
              mime = "video/*";
            }
            {
              fg = "#F3D398";
              mime = "audio/*";
            }
            {
              fg = "#CD9EFC";
              mime = "application/x-bzip";
            }
          ];
        };
      };
      settings = {
        log = {
          enabled = false;
        };
        manager = {
          show_hidden = true;
          sort_by = "modified";
          sort_dir_first = true;
          sort_reverse = true;
        };
      };
    };
  };
}

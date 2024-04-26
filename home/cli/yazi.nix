{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    cli.yazi.enable =
      lib.mkEnableOption "Enable yazi";
  };

  config = lib.mkIf config.cli.yazi.enable {
    home = {
      shellAliases.y = "yazi";
      #deps
      packages = with pkgs; [
        jq
        poppler
        fd
        ripgrep
        fzf
        zoxide
        wl-clipboard
        glow
      ];
    };
    xdg.configFile = {
      "yazi/plugins/glow.yazi/init.lua".source = "";
    };
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
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
        manager = {
          ratio = [
            0
            2
            3
          ];
          sort_by = "alphabetical";
          sort_dir_first = true;
          sort_sensitive = false;
          sort_reverse = false;
          linemode = "size";
          show_hidden = true;
        };
        sixel_fraction = 12;
        plugin = {
          prepend_previewers = [
            {
              name = "*.md";
              run = "glow";
            }
          ];
        };
      };

      theme = {
        manager = {
          preview_hovered = {
            underline = false;
          };
          folder_offset = [
            1
            0
            1
            0
          ];
          preview_offset = [
            1
            1
            1
            1
          ];
        };
      };
    };
  };
}

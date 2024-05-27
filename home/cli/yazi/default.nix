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
      # dependencies
      packages = with pkgs; [
        ripgrep
        jq
        poppler
        fd
        fzf
        zoxide
        wl-clipboard
        glow
        hexyl
        miller
        exiftool
        ouch
        bat
      ];
    };
    xdg.configFile = {
      "yazi/plugins/glow.yazi".source = ./glow.yazi;
      "yazi/plugins/hexyl.yazi".source = ./hexyl.yazi;
      "yazi/plugins/miller.yazi".source = ./miller.yazi;
      "yazi/plugins/exifaudio.yazi".source = ./exifaudio.yazi;
      "yazi/plugins/fg.yazi".source = ./fg.yazi;
      "yazi/plugins/ouch.yazi".source = ./ouch.yazi;
    };
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
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
          # show_hidden = true;
        };
        sixel_fraction = 12;
        plugin = import ./plugin.nix;
      };

      theme = {
        status = {
          separator_open = "";
          separator_close = "";
        };
        prepend_keymap = [
          {
            on = ["f" "g"];
            run = "plugin fg";
            desc = "find file by content";
          }
          {
            on = ["f" "f"];
            run = "plugin fg --args='fzf'";
            desc = "find file by file name";
          }
        ];
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

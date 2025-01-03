{
  pkgs,
  config,
  lib,
  ...
}:
let
  swayCfg = config.wayland.windowManager.sway;
  mod = swayCfg.config.modifier;
  yazi-foot = pkgs.writers.writeBash "yazi-foot" ''
    foot --app-id=yazi fish -c yazi ~
  '';
in
{
  imports = [ ./plugin.nix ];
  wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
    "${mod}+f" = "exec ddapp -t 'yazi' -c ${yazi-foot}";
  };
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
    "yazi/plugins/glow.yazi/init.lua".source = "${
      pkgs.fetchFromGitHub {
        owner = "Reledia";
        repo = "glow.yazi";
        rev = "388e847dca6497cf5903f26ca3b87485b2de4680";
        hash = "sha256-fKJ5ld5xc6HsM/h5j73GABB5i3nmcwWCs+QSdDPA9cU=";
      }
    }/init.lua";
    "yazi/plugins/hexyl.yazi/init.lua".source = "${
      pkgs.fetchFromGitHub {
        owner = "Reledia";
        repo = "hexyl.yazi";
        rev = "ccc0a4a959bea14dbe8f2b243793aacd697e34e2";
        hash = "sha256-9rPJcgMYtSY5lYnFQp3bAhaOBdNUkBaN1uMrjen6Z8g=";
      }
    }/init.lua";
    "yazi/plugins/miller.yazi/init.lua".source = "${
      pkgs.fetchFromGitHub {
        owner = "Reledia";
        repo = "miller.yazi";
        rev = "40e02654725a9902b689114537626207cbf23436";
        hash = "sha256-GXZZ/vI52rSw573hoMmspnuzFoBXDLcA0fqjF76CdnY=";
      }
    }/init.lua";
    "yazi/plugins/exifaudio.yazi/init.lua".source = "${
      pkgs.fetchFromGitHub {
        owner = "Sonico98";
        repo = "exifaudio.yazi";
        rev = "855ff055c11fb8f268b4c006a8bd59dd9bcf17a7";
        hash = "sha256-8f1iG9RTLrso4S9mHYcm3dLKWXd/WyRzZn6KNckmiCc=";
      }
    }/init.lua";
    "yazi/plugins/ouch.yazi/init.lua".source = "${
      pkgs.fetchFromGitHub {
        owner = "ndtoan96";
        repo = "ouch.yazi";
        rev = "b8698865a0b1c7c1b65b91bcadf18441498768e6";
        hash = "sha256-eRjdcBJY5RHbbggnMHkcIXUF8Sj2nhD/o7+K3vD3hHY=";
      }
    }/init.lua";

  };
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    settings = {
      preview = {
        max_width = 970;
        max_height = 970;
      };
      opener = {
        play = [
          {
            run = "mpv \"$@\"";
            orphan = true;
            for = "unix";
          }
        ];

        edit = [
          {
            run = "$EDITOR \"$@\"";
            block = true;
            for = "unix";
          }
        ];
      };
      manager = {
        ratio = [
          0
          1
          2
        ];
        sort_by = "alphabetical";
        sort_dir_first = true;
        sort_sensitive = false;
        sort_reverse = false;
        linemode = "size";
        # show_hidden = true;
      };
      sixel_fraction = 12;
    };

    theme =
      (builtins.fromTOML (
        builtins.readFile "${
          pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "yazi";
            rev = "54d868433a0c2f3e1651114136ea088eef72a4a7";
            hash = "sha256-dMXSXS3Scj1LZZqqnvvC37VWSyjSQZg9thvjcm2iNSM=";
          }
        }/themes/macchiato/catppuccin-macchiato-teal.toml"
      ))
      // {
        status = {
          separator_open = "";
          separator_close = "";
        };
        prepend_keymap = [
          {
            on = [
              "f"
              "g"
            ];
            run = "plugin fg";
            desc = "find file by content";
          }
          {
            on = [
              "f"
              "f"
            ];
            run = "plugin fg --args='fzf'";
            desc = "find file by file name";
          }
        ];
        manager = {
          # preview_hovered = {
          #   underline = false;
          # };
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
}

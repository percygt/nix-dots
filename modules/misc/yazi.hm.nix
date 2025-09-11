{
  pkgs,
  config,
  lib,
  ...
}:
let
  yazi-repo = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "d7588f6d29b5998733d5a71ec312c7248ba14555";
    hash = "sha256-9+58QhdM4HVOAfEC224TrPEx1N7F2VLGMxKVLAM4nJw=";
  };
in
{
  config = lib.mkIf config.modules.misc.yazi.enable {
    home = {
      shellAliases.y = "yazi";
      # dependences
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
        resvg
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
          rev = "ce6fb75431b9d0d88efc6ae92e8a8ebb9bc1864a";
          hash = "sha256-oUEUGgeVbljQICB43v9DeEM3XWMAKt3Ll11IcLCS/PA=";
        }
      }/init.lua";
      "yazi/plugins/smart-enter.yazi/main.lua".source = "${yazi-repo}/smart-enter.yazi/main.lua";
    };
    programs.yazi = {
      enable = true;
      settings = {
        preview = {
          max_width = 970;
          max_height = 970;
        };
        input = {
          prepend.keymap = [
            {
              on = "<esc>";
              run = "close";
              desc = "cancel input";
            }
          ];
        };
        mgr = {
          prepend.keymap = [
            {
              on = "l";
              run = "plugin smart-enter";
              desc = "Enter the child directory, or open the file";
            }
          ];
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

      theme = builtins.fromTOML (
        builtins.readFile "${
          pkgs.fetchFromGitHub {
            owner = "yazi-rs";
            repo = "flavors";
            rev = "9cd2ac4510755f3fb6bfec271827497f2db0dc4e";
            hash = "sha256-xMaZoWSetXHg772cwqBTEcdXdnGYQVaiUDcjKk9r53w=";
          }
        }/catppuccin-macchiato.yazi/flavor.toml"
      );
    };
  };
}

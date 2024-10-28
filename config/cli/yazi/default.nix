{ pkgs, ... }:
{
  imports = [ ./plugin.nix ];
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
    "yazi/plugins/glow.yazi/init.lua".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/Reledia/glow.yazi/main/init.lua";
      sha256 = "0ca7drxxm1xc78gqn7m8mffph2wdjc7hab62knp3cm39d2bvi73g";
    };
    "yazi/plugins/hexyl.yazi/init.lua".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/Reledia/hexyl.yazi/main/init.lua";
      sha256 = "0q4vbka73hx7dryhwkw39cl3smhwm18l11dqpy5y6nsamzmgyz9j";
    };
    "yazi/plugins/miller.yazi/init.lua".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/Reledia/miller.yazi/main/init.lua";
      sha256 = "0x8b3jrgginb2zddxn83h8df92jcyjxjs0x83jj0b6zv9fppq8w6";
    };
    "yazi/plugins/exifaudio.yazi/init.lua".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/Sonico98/exifaudio.yazi/master/init.lua";
      sha256 = "0vsjyd1qr5ndrg9prg60cgz03sa3qk5qha5xwaknpb6qpw09hb73";
    };
    "yazi/plugins/ouch.yazi/init.lua".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/ndtoan96/ouch.yazi/main/init.lua";
      sha256 = "1hf8h444w1m3x02nl4qqgvn33i5xnfj9qbwpa30v0sb4301vq78h";
    };
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

{
  inputs,
  pkgs,
  config,
  ...
}:
let
  g = config._global;
  modulewalker = "${g.flakeDirectory}/desktop/niri/walker";
  c = config.modules.themes.colors.withHashtag;
  f = config.modules.fonts.app;
  i = config.modules.fonts.icon;
in
{
  imports = [ inputs.walker.homeManagerModules.default ];
  home.packages = with pkgs; [
    wl-clipboard
    libqalculate
  ];
  programs.walker = {
    enable = true;
    package = pkgs.walker;
    runAsService = true;
    config = { };
  };
  xdg.configFile =
    let
      symlink = file: config.lib.file.mkOutOfStoreSymlink file;
    in
    {
      "walker/config.toml".source = symlink "${modulewalker}/config.toml";
      "elephant/websearch.toml".source = symlink "${modulewalker}/elephant/websearch.toml";
      "elephant/desktopapplications.toml".source =
        symlink "${modulewalker}/elephant/desktopapplications.toml";
      "elephant/menus".source = symlink "${modulewalker}/elephant/menus";
      "walker/themes/custom/main.css".source = symlink "${modulewalker}/main.css";
      "walker/themes/custom/layout.xml".source = symlink "${modulewalker}/layout.xml";
      "walker/themes/custom/style.css".text =
        # css
        ''
          @define-color background ${c.base00};
          @define-color background-alt ${c.base01};
          @define-color text-dark ${c.base11};
          @define-color text ${c.base05};
          @define-color black ${c.base11};
          @define-color green ${c.green};
          @define-color orange ${c.orange};
          @define-color cyan ${c.cyan};
          @define-color blue ${c.blue};
          @define-color yellow ${c.yellow};
          @define-color red ${c.red};
          @define-color magenta ${c.magenta};
          @define-color brown ${c.brown};
          * {
            all: unset;
            font-family: '${f.name}, ${i.name}';
          }
          @import url("file://${config.xdg.configHome}/walker/themes/custom/main.css");
        '';
    };
}

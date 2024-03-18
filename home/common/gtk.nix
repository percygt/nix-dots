{
  pkgs,
  config,
  username,
  flakeDirectory,
  self,
  ui,
  ...
}: let
  inherit (ui) fonts colors;
in {
  gtk = {
    enable = true;
    font = {
      
    };
    theme = {
      name = "Colloid-Dark-Nord";
      package = pkgs.colloid-gtk-theme.overrideAttrs (oldAttrs: {
        installPhase = ''
          runHook preInstall
          # override colors
          sed -i "s\#0d0e11\#${colors.default.background}\g" ./src/sass/_color-palette-nord.scss
          sed -i "s\#bf616a\#${colors.bright.red}\g" ./src/sass/_color-palette-nord.scss
          sed -i "s\#a3be8c\#${colors.normal.magenta}\g" ./src/sass/_color-palette-nord.scss
          sed -i "s\#ebcb8b\#${colors.bright.yellow}\g" ./src/sass/_color-palette-nord.scss
          sed -i "s\#3a4150\#${colors.extra.azure}\g" ./src/sass/_color-palette-nord.scss
          sed -i "s\#333a47\#${colors.extra.nocturne}\g" ./src/sass/_color-palette-nord.scss
          sed -i "s\#242932\#${colors.extra.nocturne}\g" ./src/sass/_color-palette-nord.scss
          sed -i "s\#1e222a\#${colors.extra.obsidian}\g" ./src/sass/_color-palette-nord.scss
          name= HOME="$TMPDIR" ./install.sh \
            --color dark \
            --tweaks rimless nord \
            --dest $out/share/themes
          jdupes --quiet --link-soft --recurse $out/share
          runHook postInstall
        '';
      });
    };
    cursorTheme = {
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 32;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "lavender";
      };
    };
    gtk3 = {
      bookmarks = [
        "file:///${flakeDirectory}"
        "file:///home/${username}/.local"
        "file:///home/${username}/.config"
        "file:///windows"
        "file:///backup"
        "file:///data/playground"
        "file:///data/git-repo"
        "file:///data/logs"
        "file:///data/codebox"
        "file:///data/distrobox"
        "file:///data"
        "file:///home/${username}/Documents"
        "file:///home/${username}/Music"
        "file:///home/${username}/Pictures"
        "file:///home/${username}/Videos"
        "file:///home/${username}/Downloads"
      ];
    };
  };
  xdg = {
    configFile = {
      "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
      "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    };
    dataFile = {
      "themes/${config.gtk.theme.name}".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}";
      "flatpak/overrides/global".text = ''
        [Context]
        filesystems=xdg-data/themes:ro;xdg-data/icons:ro;xdg-config/gtkrc:ro;xdg-config/gtkrc-2.0:ro;xdg-config/gtk-2.0:ro;xdg-config/gtk-3.0:ro;xdg-config/gtk-4.0:ro;/nix/store
      '';
      backgrounds.source = "${self}/lib/assets/backgrounds";
    };
  };

  home = {
    packages = with pkgs; [
      ffmpegthumbnailer
    ];
    pointerCursor = {
      inherit (config.gtk.cursorTheme) name package size;
      gtk.enable = true;
      x11.enable = true;
    };
    sessionVariables = {
      GTK_THEME = config.gtk.theme.name;
      GTK_CURSOR = config.gtk.cursorTheme.name;
      XCURSOR_THEME = config.gtk.cursorTheme.name;
      XCURSOR_SIZE = builtins.toString config.gtk.cursorTheme.size;
      GTK_ICON = config.gtk.iconTheme.name;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-theme = config.gtk.cursorTheme.name;
      gtk-theme = config.gtk.theme.name;
      icon-theme = config.gtk.iconTheme.name;
      # font-name = FONT;
    };
  };
}

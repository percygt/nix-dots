{
  lib,
  username,
  config,
  inputs,
  ...
}:
{
  # imports = [ inputs.flatpaks.nixosModule ];
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
  config = lib.mkIf config.modules.app.flatpak.enable {
    users.users.${username}.extraGroups = [ "flatpak" ];
    services.flatpak = {
      enable = true;
      packages = [
        # "flathub:app/org.libreoffice.LibreOffice/x86_64/stable"
        # "flathub:app/com.valvesoftware.Steam/x86_64/stable"
        "org.vinegarhq.Sober"
        "io.github.kolunmi.Bazaar"
        "dev.vencord.Vesktop"
        "org.gnome.gitlab.YaLTeR.VideoTrimmer"
        "org.gnome.design.Palette"
        "com.github.tchx84.Flatseal"
        "engineer.atlas.Nyxt"
        "com.rustdesk.RustDesk"
        "re.sonny.Workbench"
      ];
      remotes = [
        {
          name = "flathub";
          location = "https://flathub.org/repo/flathub.flatpakrepo";
        }
        {
          name = "flathub-beta";
          location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
        }
      ];
      overrides = {
        global.Context.filesystems = [
          "xdg-data/themes:ro"
          "xdg-data/icons:ro"
          "xdg-config/gtkrc:ro"
          "xdg-config/gtkrc-2.0:ro"
          "xdg-config/gtk-2.0:ro"
          "xdg-config/gtk-3.0:ro"
          "xdg-config/gtk-4.0:ro"
          # "xdg-config/Kvantum:ro"
          # "xdg-config/qt5ct:ro"
          # "xdg-config/qt6ct:ro"
          # "xdg-config/kdeglobals:ro"
          "/run/current-system/sw/bin:ro"
          "/nix/store:ro"
        ];
        # "com.valvesoftware.Steam" = {
        #   environment.GDK_BACKEND = "wayland steam steam://rungameid/1973530";
        #   filesystems = [ "xdg-data/steam" ];
        # };
        # "org.libreoffice.LibreOffice" = {
        #   environment.GTK_THEME = "Yaru-dark";
        # };
      };
    };
    users.users.${username}.extraGroups = [ "flatpak" ];
    persistSystem.directories = [ "/var/lib/flatpak" ];
    persistHome.directories = [
      # ".local/share/flatpak"
      ".var/app"
    ];
  };
}

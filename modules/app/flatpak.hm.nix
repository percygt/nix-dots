{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.flatpaks.homeModule ];
  config = lib.mkIf config.modules.app.flatpak.enable {
    services.flatpak = {
      enable = true;
      packages = [
        "flathub:app/dev.vencord.Vesktop/x86_64/stable"
        "flathub:app/io.qt.QtCreator/x86_64/stable"
        "flathub:app/io.qt.qtdesignstudio/x86_64/stable"
        "flathub:app/org.libreoffice.LibreOffice/x86_64/stable"
        "flathub:app/org.gnome.gitlab.YaLTeR.VideoTrimmer/x86_64/stable"
        "flathub:app/im.nheko.Nheko/x86_64/stable"
        "flathub:app/com.valvesoftware.Steam/x86_64/stable"
        "flathub:app/com.github.tchx84.Flatseal/x86_64/stable"
        "flathub:app/engineer.atlas.Nyxt/x86_64/stable"
        "flathub:app/com.rustdesk.RustDesk/x86_64/stable"
        "flathub:app/re.sonny.Workbench/x86_64/stable"
      ];
      remotes = {
        "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
      };
      overrides = {
        global = {
          filesystems = [
            "xdg-data/themes:ro"
            "xdg-data/icons:ro"
            "xdg-config/gtkrc:ro"
            "xdg-config/gtkrc-2.0:ro"
            "xdg-config/gtk-2.0:ro"
            "xdg-config/gtk-3.0:ro"
            "xdg-config/gtk-4.0:ro"
            "xdg-config/Kvantum:ro"
            "xdg-config/qt5ct:ro"
            "xdg-config/qt6ct:ro"
            "xdg-config/kdeglobals:ro"
            "/run/current-system/sw/bin:ro"
            "/nix/store:ro"
          ];
        };
        "com.valvesoftware.Steam" = {
          environment.GDK_BACKEND = "wayland steam steam://rungameid/1973530";
          filesystems = [ "xdg-data/steam" ];
        };
        "org.libreoffice.LibreOffice" = {
          filesystems = [
            "xdg-config/gtk-4.0"
            "xdg-config/gtk-3.0"
            "xdg-data/themes"
          ];
          environment.GTK_THEME = "Yaru-dark";
        };
      };
    };
  };
}

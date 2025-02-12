{
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports = [ inputs.flatpaks.nixosModules.declarative-flatpak ];
  systemd.services = {
    "home-manager-${username}" = {
      serviceConfig.TimeoutStartSec = pkgs.lib.mkForce 1200;
    };
  };

  users.users.${username}.extraGroups = [ "flatpak" ];
  services.flatpak = {
    enable = true;
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
          "/run/current-system/sw/bin:ro"
          "/nix/store:ro"
        ];
      };
      "com.valvesoftware.Steam" = {
        environment = {
          GDK_BACKEND = "wayland steam steam://rungameid/1973530";
        };
        filesystems = [
          "xdg-data/steam"
        ];
      };
      "org.libreoffice.LibreOffice" = {
        filesystems = [
          "xdg-config/gtk-4.0"
          "xdg-config/gtk-3.0"
          "xdg-data/themes"
        ];
        environment = {
          GTK_THEME = "Yaru-wartybrown-dark";
        };
      };
      "app.zen_browser.zen" = {
        filesystems = [
          "xdg-config:ro"
          "xdg-downloads"
        ];
      };
    };
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };
    packages = [
      "flathub:app/com.valvesoftware.Steam/x86_64/stable"
      "flathub:app/org.libreoffice.LibreOffice/x86_64/stable"
      "flathub:app/app.zen_browser.zen/x86_64/stable"
      "flathub:app/dev.vencord.Vesktop/x86_64/stable"
      "flathub:app/com.github.tchx84.Flatseal/x86_64/stable"
      "flathub:app/engineer.atlas.Nyxt/x86_64/stable"
    ];
  };
  modules.core.persist.systemData.directories = [ "/var/lib/flatpak" ];
  modules.core.persist.userData.directories = [ ".var/app" ];
}

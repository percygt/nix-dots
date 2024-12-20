{
  lib,
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
  systemd.services = {
    "home-manager-${username}" = {
      serviceConfig.TimeoutStartSec = pkgs.lib.mkForce 1200;
    };
  };

  users.users.${username}.extraGroups = [ "flatpak" ];
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    update = {
      onActivation = false;
      auto = {
        enable = true;
        onCalendar = "Sun 3:30";
      };
    };
    overrides = {
      "com.valvesoftware.Steam" = {
        Environment = {
          GDK_BACKEND = "wayland steam steam://rungameid/1973530";
        };
        Context = {
          filesystems = [
            "xdg-data/steam"
          ];
        };
      };
      global = {
        # Force Wayland by default
        Context = {
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
      };
      "org.libreoffice.LibreOffice" = {
        Environment = {
          GTK_THEME = "Yaru-bark-dark";
        };
      };
    };
    remotes = lib.mkOptionDefault [
      {
        name = "flathub-beta";
        location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
      }
    ];
    packages = [
      "com.valvesoftware.Steam"
      "org.libreoffice.LibreOffice"
      "io.github.zen_browser.zen"

      # "org.audacityteam.Audacity "
      # "com.github.geigi.cozy"
      # "com.obsproject.Studio"
      # "org.kde.kdenlive"
      # "com.rafaelmardojai.SharePreview"
      # "org.mozilla.Thunderbird"
      # "com.github.muriloventuroso.pdftricks"
      # "com.slack.Slack"
      # "io.beekeeperstudio.Studio"
      # "md.obsidian.Obsidian"
      # "page.codeberg.Imaginer.Imaginer"
    ];
  };
  fileSystems."/var/lib/flatpak".options = [ "exec" ];
  modules.core.persist.systemData.directories = [ "/var/lib/flatpak" ];
  modules.core.persist.userData.directories = [
    ".var/app/com.valvesoftware.Steam"
    ".var/app/org.libreoffice.LibreOffice"
    ".var/app/io.github.zen_browser.zen"
  ];
}

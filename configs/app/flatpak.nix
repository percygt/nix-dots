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
        environment = {
          GTK_THEME = "Yaru-bark-dark";
        };
      };
    };
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };
    packages = [
      "flathub:app/com.valvesoftware.Steam/x86_64/stable"
      "flathub:app/org.libreoffice.LibreOffice/x86_64/stable"
      "flathub:app/io.github.zen_browser.zen/x86_64/stable"

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
  # fileSystems."/var/lib/flatpak".options = [ "exec" ];
  modules.core.persist.systemData.directories = [ "/var/lib/flatpak" ];
  modules.core.persist.userData.directories = [
    ".var/app/com.valvesoftware.Steam"
    ".var/app/org.libreoffice.LibreOffice"
    ".var/app/io.github.zen_browser.zen"
  ];
}

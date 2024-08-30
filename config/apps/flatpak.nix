{
  lib,
  inputs,
  config,
  ...
}:
let
  g = config._general;
in
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    update = {
      onActivation = false;
      auto = {
        enable = true;
        onCalendar = "weekly"; # Default value
      };
    };
    remotes = lib.mkOptionDefault [
      {
        name = "flathub-beta";
        location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
      }
    ];
    packages = [
      "io.github.zen_browser.zen"
      # "engineer.atlas.Nyxt"
      "io.github.jorchube.monitorets"
      # "com.github.PintaProject.Pinta"
      # "org.gnome.Shotwell"
      "org.kde.digikam"
      "so.libdb.dissent"
      "org.freedesktop.Bustle"
      "io.github.bytezz.IPLookup"
      "com.github.geigi.cozy"
      "com.obsproject.Studio"
      "org.kde.kdenlive"
      "com.rafaelmardojai.SharePreview"
      "org.mozilla.Thunderbird"
      "com.github.huluti.Coulr"
      "com.github.muriloventuroso.pdftricks"
      "com.slack.Slack"
      "io.beekeeperstudio.Studio"
      "io.github.dvlv.boxbuddyrs"
      "io.github.shiftey.Desktop"
      "md.obsidian.Obsidian"
      "org.gnome.Calculator"
      "org.gnome.Firmware"
      "org.gnome.Snapshot"
      "org.libreoffice.LibreOffice"
      "org.telegram.desktop"
      "page.codeberg.Imaginer.Imaginer"
      "info.febvre.Komikku"
    ];
  };
  fileSystems."/var/lib/flatpak".options = [ "exec" ];
  home-manager.users.${g.username} = {
    xdg.dataFile = {
      "flatpak/overrides/global".text = ''
        [Context]
        filesystems=xdg-data/themes:ro;xdg-data/icons:ro;xdg-config/gtkrc:ro;xdg-config/gtkrc-2.0:ro;xdg-config/gtk-2.0:ro;xdg-config/gtk-3.0:ro;xdg-config/gtk-4.0:ro;/nix/store
      '';
    };
  };
  environment.persistence = {
    "/persist/system".directories = [ "/var/lib/flatpak" ];
    "/persist".users.${g.username}.directories = [
      ".var/app/org.telegram.desktop"
      ".var/app/info.febvre.Komikku"
      ".var/app/com.github.PintaProject.Pinta"
      ".var/app/io.github.zen_browser.zen"
    ];
  };
}

{
  lib,
  config,
  ...
}: {
  options = {
    browser.firefox.enable =
      lib.mkEnableOption "Enable firefox";
  };

  config = lib.mkIf config.browser.firefox.enable {
    programs. firefox = {
      enable = true;
      policies = {
        Preferences = let
          locked = x: {
            Status = "locked";
            Value = x;
          };
        in {
          "browser.chrome.toolbar_tips" = locked false;
          "browser.uidensity" = locked 1;
          "browser.fullscreen.autohide" = locked false;
          "browser.tabs.insertAfterCurrent" = locked true;
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = locked false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = locked false;
          "browser.urlbar.suggest.topsites" = locked false;
          "browser.urlbar.suggest.calculator" = locked true;
          "browser.urlbar.suggest.engines" = locked false;
          "browser.urlbar.suggest.searches" = locked false;
          "dom.security.https_only_mode" = locked true;
          # It looks like firefox doesn't allow font settings to be overridden
          "font.name.monospace.x-western" = locked "FiraMono Nerd Font";
          "font.size.monospace.x-western" = locked 16;
          "media.ffmpeg.vaapi.enabled" = locked true;
        };
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableSetDesktopBackground = true;
        DisableTelemetry = true;
        DisplayBookmarksToolbar = "newtab";
        DontCheckDefaultBrowser = true;
        DNSOverHTTPS = {
          Enabled = true;
          Locked = true;
        };
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
          Exceptions = [];
        };
        ExtensionSettings = {
          # https://github.com/mkaply/queryamoid/releases/tag/v0.1
          "queryamoid@kaply.com" = {
            installation_mode = "normal_installed";
            install_url = "https://github.com/mkaply/queryamoid/releases/download/v0.2/query_amo_addon_id-0.2-fx.xpi";
          };
          "uBlock0@raymondhill.net" = {
            installation_mode = "normal_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          };
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
            installation_mode = "normal_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
          };
          "{73a6fe31-595d-460b-a920-fcc0f8843232}" = {
            installation_mode = "normal_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/noscript/latest.xpi";
          };
          "myallychou@gmail.com" = {
            installation_mode = "normal_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-recommended-videos/latest.xpi";
          };
          "{9063c2e9-e07c-4c2c-9646-cfe7ca8d0498}" = {
            installation_mode = "normal_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/old-reddit-redirect/latest.xpi";
          };
          "@testpilot-containers" = {
            installation_mode = "normal_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
          };
        };
        HardwareAcceleration = true;
        Homepage = {
          URL = "chrome://browser/content/blanktab.html";
          Locked = false;
          StartPage = "none";
        };
        ManagedBookmarks = [
          {toplevel_name = "Default";}
          # {
          #   name = "Syncthing";
          #   url = "localhost:8384";
          # }
          {
            name = "Firefox Policies";
            url = "mozilla.github.io/policy-templates";
          }
        ];
        ManualAppUpdateOnly = true;
        NewTabPage = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OverrideFirstRunPage = "";
        PasswordManagerEnabled = false;
        Permissions = {
          Notifications = {
            BlockNewRequests = true;
            Locked = true;
          };
        };
        WebsiteFilter = {
          Block = [
            "*://news.ycombinator.com/*"
          ];
          Exceptions = [];
        };
      };
    };
  };
}

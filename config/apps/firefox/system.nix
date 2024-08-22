{ config, pkgs, ... }:
let
  g = config._general;
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-empty-string = {
    Value = "";
    Status = "locked";
  };
in
{
  home-manager.users.${g.username} = import ./home.nix;
  programs.firefox = {
    enable = true;
    # package = pkgs.firefox-nightly;
    # https://mozilla.github.io/policy-templates/
    # Apparently Mozilla doesn't let you set the default search engine using policies anymore >:c
    policies = {
      SearchBar = "unified";

      DontCheckDefaultBrowser = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisplayBookmarksToolbar = "never";
      DisplayMenuBar = "never"; # Disable the weird file menu that comes up when pressing alt
      TranslateEnabled = true;
      Homepage = {
        StartPage = "previous-session";
      };
      DisableSetDesktopBackground = true;
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
        Exceptions = [ ];
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
        };
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
        };
        "@testpilot-containers" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
        };
        "uMatrix@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/umatrix/latest.xpi";
        };
        "{74145f27-f039-47ce-a470-a662b129930a}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
        };
        "extension@tabliss.io" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/3940751/tabliss-2.6.0.xpi";
          installation_mode = "force_installed";
        };
      };
      HardwareAcceleration = true;
      ManagedBookmarks = [
        { toplevel_name = "NixOS"; }
        {
          name = "Syncthing";
          url = "https://localhost:8384";
        }
        {
          name = "Firefox Policies";
          url = "https://mozilla.github.io/policy-templates";
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
      Preferences = {
        # Privacy settings
        "extensions.pocket.enabled" = lock-false;
        "browser.newtabpage.pinned" = lock-empty-string;
        "browser.tabs.tabMinWidth" = 50; # Make tabs able to be smaller to prevent scrolling
        "browser.topsites.contile.enabled" = lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false; # No recommended stories
        "browser.newtabpage.activity-stream.feeds.topsites" = false; # No stupid top sites
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false; # Disable stupid pocket stuff
        "browser.urlbar.suggest.quicksuggest.sponsored" = false; # No sponsored suggestions

        # "browser.urlbar.placeholderName" = "DuckDuckGo";
        # "browser.urlbar.placeholderName.private" = "DuckDuckGo";

        "browser.aboutConfig.showWarning" = false; # No warning when going to config

        "browser.uiCustomization.state" = ''
          {
            "placements":
            {
              "widget-overflow-fixed-list":[],
              "unified-extensions-area":
              [
                "ublock0_raymondhill_net-browser-action","gdpr_cavi_au_dk-browser-action","redirector_einaregilsson_com-browser-action","_5183707f-8a46-4092-8c1f-e4515bcebbad_-browser-action","_b0a674f9-f848-9cfd-0feb-583d211308b0_-browser-action","jid0-3guet1r69sqnsrca5p8kx9ezc3u_jetpack-browser-action","_74145f27-f039-47ce-a470-a662b129930a_-browser-action","_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action","_c2c003ee-bd69-42a2-b0e9-6f34222cb046_-browser-action","_cb31ec5d-c49a-4e5a-b240-16c767444f62_-browser-action"
              ],
              "nav-bar":
              [
                "back-button",
                "forward-button",
                "stop-reload-button",
                "urlbar-container",
                "downloads-button",
                "fxa-toolbar-menu-button",
                "unified-extensions-button"
              ],
              "toolbar-menubar":["menubar-items"],
              "TabsToolbar":
              [
                "firefox-view-button",
                "tabbrowser-tabs",
                "new-tab-button"
              ],
              "PersonalToolbar":["personal-bookmarks"]
            },
            "currentVersion":20,
            "newElementCount":3
          }
        ''; # Make toolbar only have what I want
        "browser.download.autohideButton" = false; # Never hide downloads button
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false; # Disable picture in picture;

        "services.sync.engine.addons" = false; # Don't sync addons
        "services.sync.engine.prefs" = false; # Don't sync settings
        "services.sync.engine.prefs.modified" = false; # Don't sync more settings
        "services.sync.engine.bookmarks" = false; # Don't sync bookmarks
        "services.sync.declinedEngines" = "prefs,bookmarks,addons"; # Decline everything more

        "browser.download.useDownloadDir" = false; # Don't ask where to download things
        "browser.tabs.loadInBackground" = true; # Load tabs automaticlaly
        "browser.tabs.hoverPreview.enabled" = true; # Enable new preview tabs feature as of 129.0
        "mousewheel.system_scroll_override" = true; # SCROLL NORMALLY FFS

        "browser.in-content.dark-mode" = true; # Use dark mode
        "ui.systemUsesDarkTheme" = true;

        "extensions.autoDisableScopes" = 0; # Automatically enable extensions
        "extensions.update.enabled" = false; # Don't update extensions since they're sourced from rycee

        "widget.use-xdg-desktop-portal.file-picker" = 1; # Use new gtk file picker instead of legacy one
      };
    };
  };
}

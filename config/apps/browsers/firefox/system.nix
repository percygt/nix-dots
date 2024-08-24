{
  config,
  pkgs,
  lib,
  ...
}:
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
        # Disable irritating first-run stuff
        "browser.tabs.inTitlebar" = 1;
        "browser.disableResetPrompt" = true;
        "browser.download.panel.shown" = true;
        "browser.feeds.showFirstRunUI" = false;
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        "browser.rights.3.shown" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.uitour.enabled" = false;
        "startup.homepage_override_url" = "";
        "trailhead.firstrun.didSeeAboutWelcome" = true;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.addedImportButton" = true;

        # Don't ask for download dir
        "browser.download.useDownloadDir" = false;

        # Disable crappy home activity stream page
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false; # No stupid top sites
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
        "browser.newtabpage.blocked" = lib.genAttrs [
          # Youtube
          "26UbzFJ7qT9/4DhodHKA1Q=="
          # Facebook
          "4gPpjkxgZzXPVtuEoAL9Ig=="
          # Wikipedia
          "eV8/WsSLxHadrTL1gAxhug=="
          # Reddit
          "gLv0ja2RYVgxKdp0I5qwvA=="
          # Amazon
          "K00ILysCaEq8+bEqV/3nuw=="
          # Twitter
          "T9nJot5PurhJSy8n038xGA=="
        ] (_: 1);

        # Disable some telemetry
        "app.shield.optoutstudies.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.sessions.current.clean" = true;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.prompted" = 2;
        "toolkit.telemetry.rejected" = true;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.unifiedIsOptIn" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        # Disable fx accounts
        "identity.fxaccounts.enabled" = false;
        # Disable "save password" prompt
        "signon.rememberSignons" = false;
        # Harden
        "privacy.trackingprotection.enabled" = true;
        "dom.security.https_only_mode" = true;
        # Layout
        "browser.uiCustomization.state" = builtins.toJSON {
          currentVersion = 20;
          newElementCount = 5;
          dirtyAreaCache = [
            "nav-bar"
            "PersonalToolbar"
            "toolbar-menubar"
            "TabsToolbar"
            "widget-overflow-fixed-list"
          ];
          placements = {
            PersonalToolbar = [ "personal-bookmarks" ];
            TabsToolbar = [
              "tabbrowser-tabs"
              "new-tab-button"
              "alltabs-button"
            ];
            nav-bar = [
              "back-button"
              "forward-button"
              "stop-reload-button"
              "urlbar-container"
              "downloads-button"
              "ublock0_raymondhill_net-browser-action"
              "_testpilot-containers-browser-action"
              "reset-pbm-toolbar-button"
              "unified-extensions-button"
            ];
            toolbar-menubar = [ "menubar-items" ];
            unified-extensions-area = [ ];
            widget-overflow-fixed-list = [ ];
          };
          seen = [
            "save-to-pocket-button"
            "developer-button"
            "ublock0_raymondhill_net-browser-action"
            "_testpilot-containers-browser-action"
          ];
        };
        "extensions.pocket.enabled" = lock-false;
        "browser.newtabpage.pinned" = lock-empty-string;
        "browser.tabs.tabMinWidth" = 50; # Make tabs able to be smaller to prevent scrolling
        "browser.topsites.contile.enabled" = lock-false;
        "browser.compactmode.show" = true;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false; # No recommended stories
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false; # Disable stupid pocket stuff
        "browser.urlbar.suggest.quicksuggest.sponsored" = false; # No sponsored suggestions

        "browser.aboutConfig.showWarning" = false; # No warning when going to config
        "browser.download.autohideButton" = false; # Never hide downloads button
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false; # Disable picture in picture;

        "services.sync.engine.addons" = false; # Don't sync addons
        "services.sync.engine.prefs" = false; # Don't sync settings
        "services.sync.engine.prefs.modified" = false; # Don't sync more settings
        "services.sync.engine.bookmarks" = false; # Don't sync bookmarks
        "services.sync.declinedEngines" = "prefs,bookmarks,addons"; # Decline everything more

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

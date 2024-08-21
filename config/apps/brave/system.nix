{ config, lib, ... }:
let
  g = config._general;
in
{
  home-manager.users.${g.username} = {
    imports = [ ./home.nix ];
  };
  environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
    "/persist" = {
      users.${g.username} = {
        directories = [ ".config/BraveSoftware/Brave-Browser" ];
      };
    };
  };
  programs.chromium = {
    enable = true; # only enables polices to be put in etc, doesn't install chromium
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "dbepggeogbaibhgnhhndojpepiihcmeb" # xoom redirector
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
      "kbfnbcaeplbcioakkpcpgfkobkghlhen" # grammarly
      "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
    ];
    initialPrefs = {
      "https_only_mode_auto_enabled" = true;
      "privacy_guide" = {
        "viewed" = true;
      };
      "safebrowsing" = {
        "enabled" = false;
        "enhanced" = false;
      };
      "autofill" = {
        "credit_card_enabled" = false;
        # "profile_enabled" = false;
      };
      "search" = {
        "suggest_enabled" = false;
      };
      "browser" = {
        "clear_data" = {
          "cache" = false;
          "browsing_data" = false;
          "cookies" = false;
          "cookies_basic" = false;
          "download_history" = true;
          "form_data" = true;
          "time_period" = 4;
          "time_period_basic" = 4;
        };
        "has_seen_welcome_page" = true;
        "theme" = {
          "follows_system_colors" = true;
        };
      };
      "enable_do_not_track" = true;
      "https_only_mode_enabled" = true;
      "intl"."selected_languages" = "en-PH,en-US";
      "payments"."can_make_payment_enabled" = false;
    };
    extraOpts = {
      BrowserSignin = 0;
      PasswordManagerEnabled = false;
      ShowHomeButton = true;
      CloudReportingEnabled = false;
      SafeBrowsingEnabled = false;
      ReportSafeBrowsingData = false;
      AllowDinosaurEasterEgg = false;
      AllowOutdatedPlugins = true;
      AlwaysOpenPdfExternally = true;
      AdvancedProtectionAllowed = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      BackgroundModeEnabled = false;
      BatterySaverModeAvailability = 2;
      BlockThirdPartyCookies = true;
      BrowserNetworkTimeQueriesEnabled = false;
      DefaultBrowserSettingEnabled = false;
      DefaultClipboardSetting = 2;
      DefaultFileSystemReadGuardSetting = 2;
      DefaultFileSystemWriteGuardSetting = 2;
      DefaultGeolocationSetting = 2;
      DefaultLocalFontsSetting = 2;
      DefaultNotificationsSetting = 2;
      DefaultPopupsSetting = 2;
      DefaultSensorsSetting = 2;
      DefaultSerialGuardSetting = 2;
      DefaultThirdPartyStoragePartitioningSetting = 2;
      DefaultWindowManagementSetting = 2;
      DNSInterceptionChecksEnabled = false;
      DnsOverHttpsMode = "automatic";
      EnableMediaRouter = false;
      EnterpriseRealTimeUrlCheckMode = 0;
      HardwareAccelerationModeEnabled = true;
      HighEfficiencyModeEnabled = true;
      HttpsOnlyMode = "force_enabled";
      HomepageIsNewTabPage = true;
      MediaRecommendationsEnabled = false;
      MetricsReportingEnabled = false;
      NTPCardsVisible = false;
      NTPCustomBackgroundEnabled = true;
      PasswordLeakDetectionEnabled = false;
      # PasswordManagerEnabled = false;
      PromotionalTabsEnabled = false;
      PaymentMethodQueryEnabled = false;
      SafeBrowsingProtectionLevel = 0;
      # ScreenCaptureAllowed = true;
      SearchSuggestEnabled = false;
      ShoppingListEnabled = false;
      SpellcheckEnabled = false;
      SyncDisabled = true;
      # https://chromeenterprise.google/policies/#URLBlocklist
      UserAgentReduction = 2;
    };
  };
}

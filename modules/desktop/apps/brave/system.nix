{
  username,
  config,
  lib,
  ...
}:
{
  home-manager.users.${username} = {
    imports = [ ./home.nix ];
  };
  environment.persistence = lib.mkIf config.core.ephemeral.enable {
    "/persist" = {
      users.${username} = {
        directories = [ ".config/BraveSoftware/Brave-Browser" ];
      };
    };
  };
  programs.chromium = {
    enable = true; # only enables polices to be put in etc, doesn't install chromium
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm"
      "dbepggeogbaibhgnhhndojpepiihcmeb"
    ];
    extraOpts = {
      ShowHomeButton = true;
      AdvancedProtectionAllowed = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      BackgroundModeEnabled = false;
      BatterySaverModeAvailability = 2;
      BlockThirdPartyCookies = true;
      BrowserNetworkTimeQueriesEnabled = false;
      BrowserSignin = 0;
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

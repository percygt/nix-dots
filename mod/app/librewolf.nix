{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.app.librewolf.enable {
    programs.librewolf = {
      enable = true;
      settings = {
        "extensions.autoDisableScopes" = 0;
        "gnomeTheme.hideSingleTab" = true;
        "middlemouse.paste" = false;

        "browser.download.useDownloadDir" = true;
        "browser.tabs.insertAfterCurrent" = true;
        "browser.tabs.warnOnClose" = true;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.quitShortcut.disabled" = true;
        "browser.sessionstore.restore_pinned_tabs_on_demand" = true;

        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.trimHttps" = true;

        "sidebar.position_start" = false;
        "findbar.highlightAll" = true;

        "xpinstall.signatures.required" = false;

        "apz.overscroll.enabled" = false;
        "browser.tabs.hoverPreview.enabled" = true;

        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
  };
}

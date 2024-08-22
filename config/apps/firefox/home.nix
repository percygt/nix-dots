{

  programs.firefox = {
    enable = true;
    package = null;
    profiles.default = {
      isDefault = true;
      id = 0;
      name = "Home";
      settings = {
        # "browser.search.defaultenginename" = "DuckDuckGo";
        # "browser.search.order.1" = "DuckDuckGo";

        "signon.rememberSignons" = false;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "browser.aboutConfig.showWarning" = false;
        "browser.compactmode.show" = true;
        "browser.cache.disk.enable" = false; # Be kind to hard drive
        #
        # "mousewheel.default.delta_multiplier_x" = 20;
        # "mousewheel.default.delta_multiplier_y" = 20;
        # "mousewheel.default.delta_multiplier_z" = 20;

        # Firefox 75+ remembers the last workspace it was opened on as part of its session management.
        # This is annoying, because I can have a blank workspace, click Firefox from the launcher, and
        # then have Firefox open on some other workspace.
        "widget.disable-workspace-management" = true;
      };
      search = {
        force = true;
        default = "Google";
        order = [
          "Google"
          "DuckDuckGo"
        ];
      };
    };

  };
}

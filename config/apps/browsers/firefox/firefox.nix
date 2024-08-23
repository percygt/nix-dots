{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = null;
    profiles.default = {
      isDefault = true;
      id = 0;
      name = "Home";
      # settings = {
      #   "widget.use-xdg-desktop-portal.file-picker" = 1;
      #   "browser.aboutConfig.showWarning" = false;
      #   "browser.compactmode.show" = true;
      #   "browser.cache.disk.enable" = false; # Be kind to hard drive
      # };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        vimium
        clearurls
        # umatrix
        privacy-badger
        tabliss
      ];
      search = {
        force = true;
        default = "Google";
        order = [
          "Google"
        ];
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "NixOS Wiki" = {
            urls = [
              {
                template = "https://nixos.wiki/index.php?search={searchTerms}";
              }
            ];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@nw" ];
          };
          "Bing".metaData.hidden = true;
          "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
        };
      };
    };

  };
}

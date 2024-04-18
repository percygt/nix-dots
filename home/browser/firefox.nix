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
    programs.firefox = {
      enable = true;
    };
  };
}

{lib, ...}: {
  i18n.defaultLocale = lib.mkDefault "en_PH.UTF-8";
  time.timeZone = "Asia/Manila";
  
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fil_PH";
    LC_IDENTIFICATION = "fil_PH";
    LC_MEASUREMENT = "fil_PH";
    LC_MONETARY = "fil_PH";
    LC_NAME = "fil_PH";
    LC_NUMERIC = "fil_PH";
    LC_PAPER = "fil_PH";
    LC_TELEPHONE = "fil_PH";
    LC_TIME = "fil_PH";
  };

  console.keyMap = "ph";
  services.xserver = {
    xkb.layout = "ph";
    xkb.variant = "";
  };
}

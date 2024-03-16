{
  stateVersion,
  hostName,
  ...
}: {
  time.timeZone = "Asia/Manila";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_PH.UTF-8";
    LC_IDENTIFICATION = "en_PH.UTF-8";
    LC_MEASUREMENT = "en_PH.UTF-8";
    LC_MONETARY = "en_PH.UTF-8";
    LC_NAME = "en_PH.UTF-8";
    LC_NUMERIC = "en_PH.UTF-8";
    LC_PAPER = "en_PH.UTF-8";
    LC_TELEPHONE = "en_PH.UTF-8";
    LC_TIME = "en_PH.UTF-8";
  };
  console.keyMap = "us";
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };
  networking = {
    inherit hostName;
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  system.stateVersion = stateVersion;
}

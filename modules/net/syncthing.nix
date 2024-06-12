{
  username,
  config,
  lib,
  pkgs,
  homeDirectory,
  profile,
  ...
}: let
  staggeredMonth = {
    type = "staggered";
    cleanupIntervalS = 86400; # Once every day
    params = {
      maxAge = "2592000"; # Keep versions for up to a month
    };
  };
  trashcanBasic = {
    type = "trashcan";
    cleanupIntervalS = 86400; # Once every day
    params = {
      cleanoutDays = "7";
    };
  };
  images = id: {
    inherit id;
    path = "${config.services.syncthing.dataDir}/images/${id}";
    type = "receiveonly";
    fsWatcherEnabled = false;
    ignoreDelete = true;
    devices = builtins.attrNames config.services.syncthing.settings.devices;
  };
in {
  options = {
    net.syncthing = {
      enable =
        lib.mkEnableOption "Enable syncthing";
    };
  };

  config = lib.mkIf config.net.syncthing.enable {
    users = {
      users.${username}.packages = [pkgs.syncthing];
    };
    sops.secrets = {
      "syncthing/cert.pem" = {};
      "syncthing/key.pem" = {};
      "syncthing/pw" = {};
    };
    services.syncthing = {
      enable = true;
      user = username;
      openDefaultPorts = true;
      guiAddress = "${profile}.atlas-qilin.ts.net:8384";
      dataDir = "${homeDirectory}/data";
      configDir = "${homeDirectory}/data/config/syncthing";
      cert = config.sops.secrets."syncthing/cert.pem".path;
      key = config.sops.secrets."syncthing/key.pem".path;

      settings = rec {
        gui = {
          user = username;
          theme = "black";
        };
        devices.phone.id = "NMI66EH-U5GFS4R-VV32KKU-34FNTLC-CEB6KXO-A6L3E37-KZOC24S-P3PPDQQ";
        folders = {
          keeps = {
            versioning = staggeredMonth;
            path = "${config.services.syncthing.dataDir}/config/keeps";
            devices = builtins.attrNames devices;
          };
          playbook = {
            versioning = trashcanBasic;
            path = "${config.services.syncthing.dataDir}/playbook";
            devices = builtins.attrNames devices;
          };
          audiobooks = {
            path = "${config.services.syncthing.dataDir}/audiobooks";
            devices = builtins.attrNames devices;
          };
          pictures = images "pictures";
          pint = images "pint";
          pext = images "pext";
        };

        options = {
          urAccepted = -1;
          urSeen = 3;
          listenAddresses = ["default"];
          minHomeDiskFree = {
            unit = "%";
            value = 1;
          };
        };
      };
    };
  };
}

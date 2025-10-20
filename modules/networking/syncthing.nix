{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  g = config._global;
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
in
{
  config = lib.mkIf config.modules.networking.syncthing.enable {
    users.users.${username}.packages = [ pkgs.syncthing ];
    sops.secrets = {
      "syncthing/cert.pem" = { };
      "syncthing/key.pem" = { };
      "syncthing/pw" = { };
    };
    services.syncthing = {
      inherit (g.network.syncthing) guiAddress;
      enable = true;
      user = username;
      openDefaultPorts = true;
      dataDir = g.dataDirectory;
      configDir = g.syncthingDirectory;
      cert = config.sops.secrets."syncthing/cert.pem".path;
      key = config.sops.secrets."syncthing/key.pem".path;

      settings = rec {
        devices.phone.id = g.network.syncthing.devices.phone.id;
        gui = {
          user = username;
          theme = "black";
        };
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
          listenAddresses = [ "default" ];
          minHomeDiskFree = {
            unit = "%";
            value = 1;
          };
        };
      };
    };
  };
}

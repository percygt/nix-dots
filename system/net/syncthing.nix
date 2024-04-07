{
  username,
  config,
  lib,
  ...
}: {
  options = {
    net.syncthing = {
      enable =
        lib.mkEnableOption "Enable syncthing";
    };
  };

  config = lib.mkIf config.net.syncthing.enable {
    services.syncthing = {
      enable = true;
      group = "data";
    };

    users.users.${username}.extraGroups = ["syncthing"];
  };
}

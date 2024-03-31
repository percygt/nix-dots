{
  username,
  config,
  lib,
  ...
}: {
  options = {
    network.syncthing = {
      enable =
        lib.mkEnableOption "Enable syncthing";
    };
  };

  config = lib.mkIf config.network.syncthing.enable {
    services.syncthing = {
      enable = true;
      group = "data";
    };

    users.users.${username}.extraGroups = ["syncthing"];
  };
}

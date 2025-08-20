{
  lib,
  username,
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.flatpaks.nixosModule ];
  config = lib.mkIf config.modules.app.flatpak.enable {
    services.flatpak.enable = true;
    users.users.${username}.extraGroups = [ "flatpak" ];
    # modules.fileSystem.persist.systemData.directories = [ "/var/lib/flatpak" ];
    modules.fileSystem.persist.userData.directories = [
      ".local/share/flatpak"
      # ".var/app"
    ];
  };
}

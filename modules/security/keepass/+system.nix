{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.modules.security.sops.enable {
    modules.fileSystem.persist.userData.directories = [ ".config/keepassxc" ];
  };
}

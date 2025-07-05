{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.modules.security.sops.enable {
    modules.core.persist.userData.directories = [ ".config/keepassxc" ];
  };
}

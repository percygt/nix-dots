{
  config,
  username,
  lib,
  ...
}:
{
  config = lib.mkIf config.modules.security.sops.enable {
    sops.secrets.userHashedPassword.neededForUsers = true;
    users.users.${username}.hashedPasswordFile = config.sops.secrets.userHashedPassword.path;
  };
}

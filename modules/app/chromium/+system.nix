{
  config,
  lib,
  username,
  ...
}:
{
  environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
    "/persist" = {
      users.${username} = {
        directories = [
          ".config/BraveSoftware/Brave-Browser"
          ".config/chromium"
        ];
      };
    };
  };
}

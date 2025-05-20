{ config, lib, ... }:
{
  config = lib.mkIf config.modules.dev.jujutsu.enable {
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          name = config.programs.git.userName;
          email = config.programs.git.userEmail;
        };
      };
    };
  };
}

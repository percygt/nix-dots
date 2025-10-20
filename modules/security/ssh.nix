{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.security.ssh.enable {
    persistSystem.directories = [ "/etc/ssh" ];
    persistHome.directories = [
      {
        directory = ".ssh";
        mode = "0700";
      }
    ];
  };
}

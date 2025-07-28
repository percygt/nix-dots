{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.security.ssh.enable {
    modules.fileSystem.persist.systemData.directories = [ "/etc/ssh" ];
    modules.fileSystem.persist.userData.directories = [
      {
        directory = ".ssh";
        mode = "0700";
      }
    ];
  };
}

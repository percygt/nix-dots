{
  config,
  self,
  lib,
  ...
}: {
  options = {
    generic.sops = {
      enable =
        lib.mkEnableOption "Enable sops";
    };
  };

  config = lib.mkIf config.generic.sops.enable {
    sops = {
      defaultSopsFile = "${self}/home/users/percygt/user.enc.yaml";
      validateSopsFiles = false;
      gnupg = {
        home = "${config.xdg.dataHome}/gnupg";
        sshKeyPaths = [];
      };
    };
  };
}

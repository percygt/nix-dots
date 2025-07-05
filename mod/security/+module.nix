{ lib, config, ... }:
{
  options.modules.security = {
    gpg = {
      enable = lib.mkEnableOption "Enable gpg";
      sshSupport.enable = lib.mkOption {
        default = config.modules.security.gpg.enable;
        type = lib.types.bool;
        description = "Enable sshsupport";
      };
      sshSupport.authSock = lib.mkOption {
        description = "Enable ssh support";
        type = lib.types.str;
        default = "/run/user/1000/gnupg/S.gpg-agent.ssh";
      };
      pass.enable = lib.mkOption {
        default = config.modules.security.gpg.enable;
        type = lib.types.bool;
        description = "Enable gpg pass";
      };
    };
    backup.enable = lib.mkEnableOption "Enable backup";
    keepass.enable = lib.mkEnableOption "Enable keepass";
    sops.enable = lib.mkEnableOption "Enable sops";
    ssh.enable = lib.mkEnableOption "Enable ssh";
    fprintd.enable = lib.mkEnableOption "Enable fprintd";
    blocky.enable = lib.mkEnableOption "Enable blocky";
    hardening.enable = lib.mkEnableOption "Enable hardening";
    kernel.enable = lib.mkEnableOption "Enable kernel";
    extraPackages.enable = lib.mkEnableOption "Enable extraPackages";
  };
}

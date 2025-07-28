{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.security = {
    gpg = {
      enable = lib.mkEnableOption "Enable gpg";
      package = lib.mkOption {
        description = "Gpg package";
        type = lib.types.package;
        default = pkgs.gnupg;
      };
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
    borgmatic = {
      enable = lib.mkEnableOption "Enable borgmatic";
      package = lib.mkOption {
        description = "Borgmatic package";
        type = lib.types.package;
        default = pkgs.borgmatic;
      };
    };
    keepass = {
      enable = lib.mkEnableOption "Enable keepass";
      package = lib.mkOption {
        description = "Keepass package";
        type = lib.types.package;
        default = pkgs.keepassxc;
      };
    };
    sops = {
      enable = lib.mkEnableOption "Enable sops";
      package = lib.mkOption {
        description = "Sops package";
        type = lib.types.package;
        default = pkgs.sops;
      };
    };
    ssh = {
      enable = lib.mkEnableOption "Enable ssh";
      package = lib.mkOption {
        description = "Ssh package";
        type = lib.types.package;
        default = pkgs.openssh;
      };
    };
    fprintd.enable = lib.mkEnableOption "Enable fprintd";
    blocky.enable = lib.mkEnableOption "Enable blocky";
    hardening.enable = lib.mkEnableOption "Enable hardening";
    kernel.enable = lib.mkEnableOption "Enable kernel";
    extraPackages.enable = lib.mkEnableOption "Enable extraPackages";
  };
}

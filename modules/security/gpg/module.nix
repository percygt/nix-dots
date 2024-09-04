{
  config,
  lib,
  libx,
  ...
}:
let
  cfg = config.modules.security.gpg;
in
{
  options.modules.security.gpg = {
    enable = libx.enableDefault "gpg";
    sshSupport = {
      enable = lib.mkOption {
        description = "Enable ssh support";
        type = lib.types.bool;
        default = cfg.enable;
      };
      authSock = lib.mkOption {
        description = "Enable ssh support";
        type = lib.types.str;
        default = "/run/user/1000/gnupg/S.gpg-agent.ssh";
      };
    };
    pass.enable = lib.mkOption {
      description = "Enable password manager support";
      type = lib.types.bool;
      default = cfg.enable;
    };
  };

}

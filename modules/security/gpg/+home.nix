{
  pkgs,
  config,
  lib,
  ...
}:
let
  g = config._general;
  timeout = 432000;
  gpgsshctl = pkgs.writeShellApplication {
    name = "gpgsshctl";
    runtimeInputs = g.system.envPackages;
    text = builtins.readFile ./gpgsshcontrol.bash;
  };
  moduleGpg = "${g.flakeDirectory}/modules/security/gpg";
  cfg = config.modules.security.gpg;
in
{
  imports = [
    # ./module.nix
    ./pass.nix
  ];
  config = lib.mkIf config.modules.security.gpg.enable {
    home = {
      packages = lib.mkAfter [ gpgsshctl ];
      file.".gnupg/sshcontrol".source = config.lib.file.mkOutOfStoreSymlink "${moduleGpg}/sshcontrol";
      sessionVariables.SSH_AUTH_SOCK = lib.mkIf cfg.sshSupport.enable cfg.sshSupport.authSock;
    };
    programs = {
      gpg = {
        enable = true;
        inherit (g.security.gpg) package;
        mutableTrust = lib.mkDefault false;
        scdaemonSettings.disable-ccid = true;
        publicKeys = [
          {
            source = g.security.gpg.publicKeyfile;
            trust = "ultimate";
          }
        ];
      };
    };
    services.gpg-agent = {
      enable = true;
      enableSshSupport = cfg.sshSupport.enable;
      enableExtraSocket = true;
      enableScDaemon = false;
      maxCacheTtl = timeout;
      maxCacheTtlSsh = timeout;
      defaultCacheTtl = timeout;
      defaultCacheTtlSsh = timeout;
      pinentryPackage = if config.gtk.enable then pkgs.pinentry-gnome3 else pkgs.pinentry-curses;
    };
  };
}

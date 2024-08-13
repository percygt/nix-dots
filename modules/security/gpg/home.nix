{
  pkgs,
  config,
  lib,
  libx,
  ...
}:
let
  g = config._general;
  timeout = 432000;
  gpgsshctl = pkgs.writeShellApplication {
    name = "gpgsshctl";
    runtimeInputs = g.envPackages;
    text = builtins.readFile ./gpgsshcontrol.bash;
  };
  moduleGpg = "${g.flakeDirectory}/modules/security/gpg";
in
{
  imports = [ ./pass.nix ];
  options.modules.security.gpg.enable = libx.enableDefault "gpg";
  config = lib.mkIf config.modules.security.gpg.enable {
    home.packages = lib.mkAfter [ gpgsshctl ];
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
    home.file.".gnupg/sshcontrol".source = config.lib.file.mkOutOfStoreSymlink "${moduleGpg}/sshcontrol";
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
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

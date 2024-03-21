{
  pkgs,
  config,
  ...
}: let
  timeout = 432000;
in {
  programs = {
    gpg.enable = true;
    fish.shellInit = ''
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK=$(${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)
    '';
  };
  services.gpg-agent = {
    enableSshSupport = true;
    enableExtraSocket = true;
    maxCacheTtl = timeout;
    maxCacheTtlSsh = timeout;
    defaultCacheTtl = timeout;
    defaultCacheTtlSsh = timeout;
    enable = true;
    sshKeys = [
      "E7FC17A1A41AD93D71B6B5A9853A9AA3ECBFCB53"
      "0F35FAA58C77270C1FC8CC77D2B107310955DD82"
    ];
    pinentryPackage = pkgs.pinentry-curses;
    extraConfig = ''
      debug-pinentry
      debug-level 1024
      disable-scdaemon
    '';
  };
}

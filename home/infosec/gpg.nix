{
  pkgs,
  config,
  lib,
  ...
}: let
  timeout = 432000;
in {
  options.infosec = {
    gpg.enable = lib.mkEnableOption "Enable gpg";
  };

  config = lib.mkIf config.infosec.gpg.enable {
    # https://wiki.archlinux.org/title/Paperkey
    home.packages = with pkgs; [paperkey zbar qrencode];
    programs = {
      gpg = {
        enable = true;
        homedir = "${config.xdg.dataHome}/gnupg";
      };
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
      pinentryPackage = pkgs.pinentry-gnome3;
      extraConfig = ''
        disable-scdaemon
      '';
    };
  };
}

{
  pkgs,
  config,
  lib,
  ...
}: let
  timeout = 432000;
  gpg-sshid-ctl = pkgs.writeShellApplication {
    name = "gpg-sshid-ctl";
    runtimeInputs = with pkgs; [openssh gnupg];
    text = builtins.readFile ../bin/gpg-sshid-ctl.sh;
  };
in {
  options.infosec = {
    gpg.enable = lib.mkEnableOption "Enable gpg";
  };

  config = lib.mkIf config.infosec.gpg.enable {
    home.packages = lib.mkAfter [gpg-sshid-ctl];
    programs = {
      gpg = {
        enable = true;
        homedir = "${config.xdg.dataHome}/gnupg";
        mutableKeys = lib.mkDefault false;
      };
      fish.shellInit = ''
        gpg-connect-agent /bye
        export SSH_AUTH_SOCK=$(${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)
      '';
    };

    # gnome-keyring is greedy and will override SSH_AUTH_SOCK where undesired
    # services.gnome-keyring.enable = lib.mkDefault false;

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
      pinentryPackage =
        if config.gtk.enable
        then pkgs.pinentry-gnome3
        else pkgs.pinentry-curses;
      extraConfig = ''
        disable-scdaemon
      '';
    };
  };
}

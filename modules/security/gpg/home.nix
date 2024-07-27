{
  pkgs,
  config,
  lib,
  flakeDirectory,
  ...
}:
let
  timeout = 432000;
  gpgsshctl = pkgs.writeShellApplication {
    name = "gpgsshctl";
    runtimeInputs = with pkgs; [
      openssh
      gnupg
    ];
    text = builtins.readFile ./gpgsshcontrol.bash;
  };
  hmGpg = "${flakeDirectory}/modules/security/gpg";
in
{
  imports = [ ./pass.nix ];
  options.modules.security.gpg.enable = lib.mkEnableOption "Enable gpg";

  config = lib.mkIf config.modules.security.gpg.enable {
    home.packages = lib.mkAfter [ gpgsshctl ];
    services.gnome-keyring.components = [ "secrets" ];
    programs = {
      gpg = {
        enable = true;
        homedir = "${config.xdg.dataHome}/gnupg";
        mutableKeys = lib.mkDefault false;
        mutableTrust = lib.mkDefault false;
        scdaemonSettings.disable-ccid = true;
        publicKeys = [
          {
            source = /persist/home/percygt/keys/public.asc;
            trust = "ultimate";
          }
        ];
      };
    };
    xdg.dataFile."${config.programs.gpg.homedir}/sshcontrol".source = config.lib.file.mkOutOfStoreSymlink "${hmGpg}/sshcontrol";
    services.gpg-agent = {
      enableSshSupport = true;
      enableExtraSocket = true;
      maxCacheTtl = timeout;
      maxCacheTtlSsh = timeout;
      defaultCacheTtl = timeout;
      defaultCacheTtlSsh = timeout;
      enable = true;
      pinentryPackage = if config.gtk.enable then pkgs.pinentry-gnome3 else pkgs.pinentry-curses;
      extraConfig = ''
        disable-scdaemon
      '';
    };
  };
}

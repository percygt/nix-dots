{
  pkgs,
  config,
  lib,
  ...
}:
let
  timeout = 432000;
in
{
  imports = [ ./pass.nix ];
  options.modules.security.gpg.enable = lib.mkEnableOption "Enable gpg";

  config = lib.mkIf config.modules.security.gpg.enable {
    programs = {
      gpg = {
        enable = true;
        homedir = "${config.xdg.dataHome}/gnupg";
        mutableKeys = lib.mkDefault false;
        mutableTrust = lib.mkDefault false;
        scdaemonSettings.disable-ccid = true;
        settings = {
          fixed-list-mode = true;
          keyid-format = "0xlong";
          personal-digest-preferences = builtins.concatStringsSep " " [
            "SHA512"
            "SHA384"
            "SHA256"
          ];
          personal-cipher-preferences = builtins.concatStringsSep " " [
            "AES256"
            "AES192"
            "AES"
          ];
          default-preference-list = builtins.concatStringsSep " " [
            "SHA512"
            "SHA384"
            "SHA256"
            "AES256"
            "AES192"
            "AES"
            "ZLIB"
            "BZIP2"
            "ZIP"
            "Uncompressed"
          ];
          use-agent = true;
          verify-options = "show-uid-validity";
          list-options = "show-uid-validity";
          cert-digest-algo = "SHA512";
          throw-keyids = false;
          no-emit-version = true;
        };
      };
      fish.shellInit =
        lib.mkIf (config.modules.shell.userDefaultShell == "fish")
          #fish
          ''
            set -e SSH_AGENT_PID
            if test -z $gnupg_SSH_AUTH_SOCK_BY; or test $gnupg_SSH_AUTH_SOCK_BY -ne $fish_pid
                set -gx SSH_AUTH_SOCK (${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)
            end
            set -gx GPG_TTY (tty)
            ${config.programs.gpg.package}/bin/gpg-connect-agent updatestartuptty /bye >/dev/null
          '';
      bash.profileExtra =
        lib.mkIf (config.modules.shell.userDefaultShell == "bash")
          #bash
          ''
            unset SSH_AGENT_PID
            if [ "''${gnupg_SSH_AUTH_SOCK_by: -0}" -ne $$ ]; then
              export SSH_AUTH_SOCK="$(${config.programs.gpg.package}/bin/gpgconf --list-dirs agent-ssh-socket)"
            fi
            export GPG_TTY=$(tty)
            ${config.programs.gpg.package}/bin/gpg-connect-agent updatestartuptty /bye >/dev/null
          '';
    };
    xdg.dataFile."${config.programs.gnupg.homedir}/sshcontrol".source = config.lib.file.mkOutOfStoreSymlink ./sshcontrol;
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

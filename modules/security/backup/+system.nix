{
  config,
  pkgs,
  lib,
  ...
}:
let
  g = config._base;
  bak = g.security.borgmatic;
  backupMountPath = bak.mountPath;
in
{
  imports = [ ./borgmatic.nix ];
  # services.borgbackup.jobs.data = {
  #   repo = "${backupMountPath}/borg/data";
  #   paths = g.dataDirectory;
  #   removableDevice = true;
  #   encryption.mode = "keyfile-blake2";
  #   encryption.passCommand = "cat ${config.sops.secrets."borgmatic/encryption".path}";
  #   preHook = lib.mkBefore ''
  #     ${pkgs.util-linux}/bin/findmnt ${backupMountPath} >/dev/null || echo '${bak.usbId}' | tee /sys/bus/usb/drivers/usb/bind &>/dev/null
  #     until ${pkgs.util-linux}/bin/findmnt ${backupMountPath} >/dev/null; do :; done
  #   '';
  #   postHook = ''
  #     echo '${bak.usbId}' | tee /sys/bus/usb/drivers/usb/unbind &>/dev/null
  #   '';
  #   compression = "auto,zstd";
  #   startAt = "daily";
  #   exclude = [
  #     "*.img"
  #     "*.iso"
  #     "*.qcow"
  #     "${g.dataDirectory}/.Trash-*"
  #   ];
  # };
}

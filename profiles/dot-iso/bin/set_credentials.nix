{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (
      writeShellScriptBin "set_credentials"
      ''
        set -euo pipefail
        if ! findmnt /home/nixos/usb >/dev/null; then
          sudo cryptsetup luksOpen /dev/disk/by-uuid/cbba3a5a-81e5-4146-8895-641602b712a5 luksvol
          sudo systemctl daemon-reload
          sleep 1
          mkdir "$HOME/usb"
          sudo mount /dev/mapper/luksvol "$HOME/usb"
          gpg --import "$HOME/usb/.k/pgp/dev/subkeys.gpg"
          sleep 1
          cp -f "$HOME/usb/credentials"  "$HOME/.config/git/"
        fi
      ''
    )
  ];
}

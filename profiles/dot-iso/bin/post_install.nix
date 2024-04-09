{
  pkgs,
  flakeDirectory,
  target_user,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (
      writeShellScriptBin "post_install"
      ''
        set -euo pipefail
        TARGET_HOST=$1
        dots_dir=${flakeDirectory};
        sec_dir="$HOME/sikreto";

        mkdir -p "/mnt/home/${target_user}/.nixos/nix-dots"
        rsync -a --delete "$dots_dir" "/mnt/home/${target_user}/.nixos"
        rsync -a --delete "$sec_dir" "/mnt/home/${target_user}/.nixos"

        sudo chmod -R 700 /mnt/home/${target_user}/.nixos
        sudo chmod 400 /mnt/home/${target_user}/.nixos/keys/home-sops.keyfile

        [ -d "$HOME/usb/.k/sops/$TARGET_HOST" ] || mkdir -p "$HOME/usb/.k/sops/$TARGET_HOST"
        cp -rf /tmp/*.keyfile "$HOME/usb/.k/sops/$TARGET_HOST/"

        findmnt /home/nixos/usb >/dev/null && sudo udisksctl unmount -b /dev/disk/by-uuid/cbba3a5a-81e5-4146-8895-641602b712a5
        sudo cryptsetup luksClose /dev/disk/by-uuid/c59596c4-62e3-4d00-a7e5-aea9d19ea3f9
      ''
    )
  ];
}

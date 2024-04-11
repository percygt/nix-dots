{
  pkgs,
  targetUser,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (
      writeShellScriptBin "install_nixos"
      ''
        set -euo pipefail
        TARGET_HOST=$1
        dots_dir="$HOME/nix-dots";
        [ -d "/mnt/etc/nixos/keys" ] || sudo mkdir -p "/mnt/etc/nixos/keys"
        if [[ -f "/tmp/data.keyfile" ]]; then
          sudo cp "/tmp/data.keyfile" "/mnt/etc/nixos/keys"
          sudo chmod 400 "/mnt/etc/nixos/keys/data.keyfile"
        fi

        sudo cp -r /tmp/system-sops.keyfile "/mnt/etc/nixos/keys/"
        sudo chmod -R 400 /mnt/etc/nixos/keys/*-sops.keyfile

        if [ -d "/mnt/home/${targetUser}/.nixos" ]; then
          sudo mkdir -p "/mnt/home/${targetUser}/.nixos/keys"
          sudo chown -R 1000:users "/mnt/home/${targetUser}/.nixos"
        fi
        sudo cp /tmp/home-sops.keyfile "/mnt/home/${targetUser}/.nixos/keys/"
        sudo chmod -R 700 /mnt/home/${targetUser}/.nixos
        sudo chmod 400 /mnt/home/${targetUser}/.nixos/keys/home-sops.keyfile
        sudo chown 1000:users /mnt/home/${targetUser}/.nixos/keys/home-sops.keyfile

        sudo nixos-install --flake "$dots_dir#$TARGET_HOST" --no-root-passwd
      ''
    )
  ];
}

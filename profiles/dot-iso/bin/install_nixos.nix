{
  pkgs,
  flakeDirectory,
  target_user,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (
      writeShellScriptBin "install_nixos"
      ''
        set -euo pipefail
        TARGET_HOST=$1
        dots_dir=${flakeDirectory};
        [ -d "/mnt/etc/nixos/keys" ] || sudo mkdir -p "/mnt/etc/nixos/keys"
        if [[ -f "/tmp/data.keyfile" ]]; then
          sudo cp "/tmp/data.keyfile" "/mnt/etc/nixos/keys"
          sudo chmod 400 "/mnt/etc/nixos/keys/data.keyfile"
        fi

        sudo cp -r /tmp/system-sops.keyfile "/mnt/etc/nixos/keys/"
        sudo chmod -R 400 /mnt/etc/nixos/keys/*-sops.keyfile

        [ -d "/mnt/home/${target_user}/.nixos/keys" ] || mkdir -p "/mnt/home/${target_user}/.nixos/keys"
        cp /tmp/home-sops.keyfile "/mnt/home/${target_user}/.nixos/keys/"
        sudo chmod -R 700 /mnt/home/${target_user}/.nixos
        sudo chmod 400 /mnt/home/${target_user}/.nixos/keys/home-sops.keyfile
        sudo chown 0:0 /mnt/home/${target_user}/.nixos/keys/home-sops.keyfile

        sudo nixos-install --flake "$dots_dir#$TARGET_HOST" --no-root-passwd
      ''
    )
  ];
}

{
  pkgs,
  targetUser,
  flakeDirectory,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (
      writeShellScriptBin "install_nixos"
      ''
        set -euo pipefail
        TARGET_HOST=$1
        dots_dir="${flakeDirectory}";
        [ -d "/mnt/var/keys" ] || sudo mkdir -p "/mnt/var/keys"
        if [[ -f "/tmp/data.keyfile" ]]; then
          sudo cp "/tmp/data.keyfile" "/mnt/var/keys"
          sudo chmod 400 "/mnt/var/keys/data.keyfile"
        fi

        sudo cp /tmp/system-sops.keyfile "/mnt/var/keys/"
        sudo chmod -R 400 /mnt/var/keys/*-sops.keyfile

        [ -d "/mnt/home/${targetUser}/.nixos" ] || sudo mkdir -p "/mnt/home/${targetUser}/.var/keys"
        sudo chown -R 1000:users "/mnt/home/${targetUser}/.nixos"
        sudo cp /tmp/home-sops.keyfile "/mnt/home/${targetUser}/.var/keys/"
        sudo chown -R 1000:users "/mnt/home/${targetUser}/.nixos"
        sudo chmod -R 700 /mnt/home/${targetUser}/.nixos
        sudo chmod 400 /mnt/home/${targetUser}/.var/keys/home-sops.keyfile

        sudo nixos-install --flake "$dots_dir#$TARGET_HOST" --no-root-passwd
      ''
    )
  ];
}

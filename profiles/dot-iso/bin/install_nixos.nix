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
        [ -d "/mnt/etc/secrets" ] || sudo mkdir -p "/mnt/etc/secrets"
        [ -d "/mnt/home/.config/sops/age" ] || mkdir -p "/mnt/home/${target_user}/.config/sops/age"

        if [[ -f "/tmp/data.keyfile" ]]; then
          sudo cp "/tmp/data.keyfile" "/mnt/etc/secrets"
          sudo chmod 0400 "/mnt/etc/secrets/data.keyfile"
        fi

        sudo cp -r /tmp/system-sops.keyfile "/mnt/etc/secrets/"
        sudo chmod -R 400 /mnt/etc/secrets/*-sops.keyfile

        sudo cp -r /tmp/home-sops.keyfile "/mnt/home/${target_user}/.config/sops/age"
        sudo chmod -R 700 /mnt/home/${target_user}/.config/sops
        sudo chmod 600 /mnt/home/${target_user}/.config/home-sops.keyfile

        sudo nixos-install --flake "$dots_dir#$TARGET_HOST" --no-root-passwd
      ''
    )
  ];
}

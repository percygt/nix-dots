{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gum
    rsync
    age
    sops
    yq-go
    (
      writeShellScriptBin "mkNixos"
      ''
        set -euo pipefail

        if [ "$(id -u)" -eq 0 ]; then
        	echo "ERROR! $(basename "$0") should be run as a regular user"
        	exit 1
        fi

        gum confirm  --default=true \
          "Confirm that you have mounted your drive for credential setup."

        set_credentials

        clone_repos

        dots_dir="$HOME/nix-dots";

        TARGET_HOST=$(ls -1 "$dots_dir"/profiles/*/configuration.nix | cut -d'/' -f6 | grep -v "iso" | gum choose)

        if [ ! -e "$dots_dir/profiles/$TARGET_HOST/disks.nix" ]; then
          echo "ERROR! $(basename "$0") could not find the required $dots_dir/profiles/$TARGET_HOST/disks.nix"
          exit 1
        fi

        set_secrets $TARGET_HOST

        set_disks $TARGET_HOST

        install_nixos $TARGET_HOST

        post_install $TARGET_HOST
      ''
    )
  ];
}

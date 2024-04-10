{
  pkgs,
  flakeDirectory,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (
      writeShellScriptBin "set_disks" ''
        set -euo pipefail
        TARGET_HOST=$1
        dots_dir=${flakeDirectory};
        gum confirm  --default=true \
          "WARNING!!!! This will ERASE ALL DATA on the disks $TARGET_HOST. Are you sure you want to continue?"

        echo "Partitioning Disks"
        sudo nix run github:nix-community/disko \
          --extra-experimental-features "nix-command flakes" \
          --no-write-lock-file \
          -- \
          --mode zap_create_mount \
          "$dots_dir/profiles/$TARGET_HOST/disks.nix"
      ''
    )
  ];
}

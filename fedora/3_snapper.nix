{pkgs, ...}:
pkgs.writeShellScriptBin "3_fedora_snapper" ''
  set -eu

  [ "$UID" -eq 0 ] || {
  	echo "This script must be run as root."
  	exit 1
  }

  echo -e "Installing snapper . . .\n"
  dnf install snapper python3-dnf-plugin-snapper -y

  snapper -c root create-config /
  snapper -c home create-config /home

  snapper list-configs

  snapper -c root set-config ALLOW_USERS="$SUDO_USER" SYNC_ACL=yes
  snapper -c home set-config ALLOW_USERS="$SUDO_USER" SYNC_ACL=yes

  ROOT_UUID="$(grub2-probe --target=fs_uuid /)"
  OPTIONS="compress=lzo"

  SUBVOLUMES=(
  	".snapshots"
  	"home/.snapshots"
  )

  for dir in "''${SUBVOLUMES[@]}"; do
  	printf "%-41s %-35s %-5s %-s %-s\n" \
  		"UUID=''${ROOT_UUID}" \
  		"/''${dir}" \
  		"btrfs" \
  		"subvol=''${dir},''${OPTIONS}" \
  		"0 0" |
  		tee -a /etc/fstab
  done

  systemctl daemon-reload
  mount -va

  btrfs subvolume list /

  echo 'PRUNENAMES = ".snapshots"' | tee -a /etc/updatedb.conf
  echo 'SUSE_BTRFS_SNAPSHOT_BOOTING="true"' | tee -a /etc/default/grub
  sed -i '1i set btrfs_relative_path="yes"' /boot/efi/EFI/fedora/grub.cfg
  grub2-mkconfig -o /boot/grub2/grub.cfg
''

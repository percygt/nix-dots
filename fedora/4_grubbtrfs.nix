{pkgs, ...}:
pkgs.writeShellScriptBin "4_fedora_grubbtrfs" ''
  set -eu

  [ "$UID" -eq 0 ] || {
  	echo "This script must be run as root."
  	exit 1
  }

  git clone https://github.com/Antynea/grub-btrfs

  cd grub-btrfs

  sed -i '/#GRUB_BTRFS_SNAPSHOT_KERNEL/a GRUB_BTRFS_SNAPSHOT_KERNEL_PARAMETERS="systemd.volatile=state"' config
  sed -i '/#GRUB_BTRFS_GRUB_DIRNAME/a GRUB_BTRFS_GRUB_DIRNAME="/boot/grub2"' config
  sed -i '/#GRUB_BTRFS_MKCONFIG=/a GRUB_BTRFS_MKCONFIG=/sbin/grub2-mkconfig' config
  sed -i '/#GRUB_BTRFS_SCRIPT_CHECK=/a GRUB_BTRFS_SCRIPT_CHECK=grub2-script-check' config

  make install

  grub2-mkconfig -o /boot/grub2/grub.cfg

  systemctl enable --now grub-btrfsd.service

  cd ..

  rm -rvf grub-btrfs

  mkdir -v /.snapshots/1

  cat >/.snapshots/1/info.xml <<EOF
  <?xml version="1.0"?>
  <snapshot>
    <type>single</type>
    <num>1</num>
    <date>$(date -u +"%F %T")</date>
    <description>first root subvolume</description>
  </snapshot>
  EOF

  btrfs subvolume snapshot / /.snapshots/1/snapshot

  SNAP_ID="$(btrfs inspect-internal rootid /.snapshots/1/snapshot)"

  btrfs subvolume set-default "$SNAP_ID" /

  grub2-mkconfig -o /boot/grub2/grub.cfg

  systemctl reboot
''

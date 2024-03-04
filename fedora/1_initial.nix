{pkgs, ...}: let
  CUR_DIR = builtins.toString ./.;
in
  pkgs.writeShellScriptBin "1_fedora_initial" ''
    set -eu

    [ "$UID" -eq 0 ] || {
    	echo "This script must be run as root."
    	exit 1
    }

    echo -e "Mounting storages ..."
    sed -i 's/zstd:1/lzo/g' /etc/fstab
    OPTIONS="compress=lzo"
    DATA=$(lsblk -f | awk '/DATA/{print $4}')
    BACKUP=$(lsblk -f | awk '/BACKUP/{print $4}')
    WINDOWS=$(lsblk -f | awk '/WINDOWS/{print $4}')

    fstab_write() {
    	local uuid=$1
    	local dir=$2
    	local fs=$3
    	local na
    	na=$([[ $4 == 1 ]] && echo ",noatime")
    	printf "%-41s %-35s %-5s %-s %-s\n" \
    		"UUID=''${uuid}" \
    		"/''${dir}" \
    		"$fs" \
    		"''${OPTIONS}''${na}" \
    		"0 0" |
    		tee -a /etc/fstab
    }

    fstab_write "$DATA" "data" "btrfs" 0
    fstab_write "$BACKUP" "backup" "btrfs" 1
    fstab_write "$WINDOWS" "windows" "auto" 1

    systemctl daemon-reload
    mount -va

    echo -e "Setting filesystem label as 'FEDORA' . . .\n"
    btrfs filesystem label / FEDORA

    btrfs filesystem show

    [ -e ${CUR_DIR}/repos ] && cp -Rnvp ${CUR_DIR}/repos/* /etc/yum.repos.d/

    chown "$SUDO_USER" -R /data

    systemctl reboot
  ''

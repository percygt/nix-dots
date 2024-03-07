{pkgs, ...}:
pkgs.writeShellScriptBin "7_fedora_homesetup" ''
  set -eu

  [ "$UID" -ne 0 ] || {
  	echo "This script must be run by $SUDO_USER."
  	exit 1
  }

  FOLDERS=("$(find /data/stow_home/* -maxdepth 0 -type d | awk -F/ '{print $4}' | tr '\n' ' ')")

  for dir in "''${FOLDERS[@]}"; do
  	[[ -e "$HOME/''${dir}" ]] && [[ ! -L "$HOME/''${dir}" ]] && rm -rf "$HOME/''${dir}"
  done

  echo "starting stow. . ."
  stow -d /data/ -t "$HOME" stow_home/
  [[ -e /data ]] && rsync -av --delete --ignore-existing "/data/com.brave.Browser" "$HOME/.var/app/"

  echo "Reboot to apply changes"
''

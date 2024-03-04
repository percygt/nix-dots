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

  ##---------------------------------------------------------------------------------------------------------------------

  echo "starting rsync. . ."
  # Check if yq is installed
  if ! command -v yq &>/dev/null; then
  	echo "yq is not installed. Please install it before running this script."
  	exit 1
  fi

  config="/data/rsync_home/config.yaml"
  # Read YAML using yq
  root_data_dir=$(yq -r '.root_data_dir' "$config")
  root_home_dir=$(yq -r '.root_home_dir' "$config")

  # Loop through items and perform rsync
  items=$(yq -c '.items[]' "$config")
  while IFS= read -r items; do
  	data_dir=$(echo "$items" | yq -r '.data_dir')
  	home_dir=$(echo "$items" | yq -r '.home_dir')

  	# Run rsync command
  	rsync -av --ignore-existing "$root_data_dir/$data_dir/" "$root_home_dir/$home_dir/"
  done <<<"$items"

  echo "Reboot to apply changes"
''

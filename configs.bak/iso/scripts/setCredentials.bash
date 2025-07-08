#!/usr/bin/env bash
set -euo pipefail
if ! findmnt /home/nixos/usb >/dev/null; then
	gum confirm --default=true \
		"Confirm that you have mounted your drive for credential setup."

	sudo cryptsetup luksOpen "$MOUNT_DEVICE" luksvol
	sudo systemctl daemon-reload
	sleep 1
	[ -d "$HOME/usb" ] || mkdir -p "$HOME/usb"
	sudo mount /dev/mapper/luksvol "$HOME/usb"
	gpg --import "$HOME/usb/.k/pgp/dev/subkeys.gpg"
	sleep 1
fi

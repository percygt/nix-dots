#!/usr/bin/env bash
set -euo pipefail
MNT=$1
if ! findmnt /home/nixos/usb >/dev/null; then
	gum confirm --default=true \
		"Confirm that you have mounted your drive for credential setup."

	sudo cryptsetup luksOpen "$MNT" luksvol
	sudo systemctl daemon-reload
	sleep 1
	mkdir "$HOME/usb"
	sudo mount /dev/mapper/luksvol "$HOME/usb"
	gpg --import "$HOME/usb/.k/pgp/dev/subkeys.gpg"
	sleep 1
fi

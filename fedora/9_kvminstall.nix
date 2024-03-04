{pkgs, ...}:
pkgs.writeShellScriptBin "9_fedora_kvminstall" ''
  set -eu

  [ "$UID" -ne 0 ] || {
  	echo "This script must be run by $SUDO_USER."
  	exit 1
  }

  sudo dnf install qemu-kvm libvirt virt-install virt-manager virt-viewer edk2-ovmf swtpm qemu-img guestfs-tools libosinfo tuned virtio-win

  for drv in qemu interface network nodedev nwfilter secret storage; do
  	sudo systemctl enable virt"''${drv}"d.service
  	sudo systemctl enable virt"''${drv}"d{,-ro,-admin}.socket
  done

  sudo reboot
''

{pkgs, ...}: let
  wallpaper = builtins.toString ../assets/gradient1.png;
in
  pkgs.writeShellScriptBin "6_fedora_grubtheme" ''
    set -eu

    [ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;} # Need to figure out how to pkexec so we only ask for the password once.

    wget -P /tmp https://github.com/shvchk/poly-dark/raw/master/install.sh

    bash /tmp/install.sh

    cp ${wallpaper} /boot/grub2/themes/poly-dark/background.png

    cat /etc/default/grub
  ''

{pkgs, ...}: let
  CUR_DIR = builtins.toString ./.;
in
  pkgs.writeShellScriptBin "8_fedora_appinstall" ''
    set -eu

    [ "$UID" -ne 0 ] || {
    	echo "This script must be run by $SUDO_USER."
    	exit 1
    }
    ## list all flatpaks into a txt file for quick install
    # flatpak list --columns=application --app >flatpaks.txt

    #rpm apps install
    xargs sudo dnf install -y <${CUR_DIR}/files/dnf_apps.txt
    sudo flatpak remote-modify --collection-id=org.flathub.Stable flathub

    #Flatpak apps offline install if local repo exist
    [ -d /data/flatpak-repo ] && xargs flatpak install -y --sideload-repo=/data/flatpak-repo/.ostree/repo/ <${CUR_DIR}/files/flatpaks-offline.txt

    #Flatpak apps online install
    xargs flatpak install -y <${CUR_DIR}/files/flatpaks.txt

    flatpak update -y

    #Update flatpak local repo
    [ -d /data/flatpak-repo ] && xargs flatpak create-usb /data/flatpak-repo --allow-partial <${CUR_DIR}/files/flatpaks-offline.txt
  ''

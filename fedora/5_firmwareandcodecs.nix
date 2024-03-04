{pkgs, ...}:
pkgs.writeShellScriptBin "5_fedora_firmwareandcodecs" ''
  set -eu

  [ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;} # Need to figure out how to pkexec so we only ask for the password once.

  #multimedia codecs
  dnf groupupdate 'core' 'multimedia' 'sound-and-video' --setop='install_weak_deps=False' --exclude='PackageKit-gstreamer-plugin' --allowerasing -y && sync
  dnf swap 'ffmpeg-free' 'ffmpeg' --allowerasing -y
  dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg -y
  dnf install lame\* --exclude=lame-devel -y
  dnf group upgrade --with-optional Multimedia -y

  #vaapi h/w video decoding
  dnf install ffmpeg ffmpeg-libs libva libva-utils -y
  dnf install intel-media-driver -y

  #openh264
  dnf install openh264 gstreamer1-plugin-openh264 mozilla-openh264 -y

  #thumnailer
  dnf install ffmpegthumbnailer -y

  #firmware update
  fwupdmgr get-devices
  fwupdmgr refresh --force
  fwupdmgr get-updates
  fwupdmgr update
''

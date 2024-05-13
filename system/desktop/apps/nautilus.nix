{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      ffmpegthumbnailer
      gnome.nautilus
      libheif.bin
      libheif.out
      nufraw
    ];
  };
}

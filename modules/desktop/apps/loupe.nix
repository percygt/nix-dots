{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ loupe ];
  xdg.desktopEntries."org.gnome.Loupe" = {
    name = "Image Viewer";
    exec = "env GTK_THEME=${config.gtk.theme.name} loupe %U";
    terminal = false;
    icon = "org.gnome.Loupe";
    type = "Application";
    categories = [
      "GNOME"
      "GTK"
      "Graphics"
      "2DGraphics"
      "RasterGraphics"
      "Viewer"
    ];
    startupNotify = true;
    settings = {
      DBusActivatable = "true";
    };
    mimeType = [
      "image/jpeg"
      "image/png"
      "image/gif"
      "image/webp"
      "image/tiff"
      "image/x-tga"
      "image/vnd-ms.dds"
      "image/x-dds"
      "image/bmp"
      "image/vnd.microsoft.icon"
      "image/vnd.radiance"
      "image/x-exr"
      "image/x-portable-bitmap"
      "image/x-portable-graymap"
      "image/x-portable-pixmap"
      "image/x-portable-anymap"
      "image/x-qoi"
      "image/svg+xml"
      "image/svg+xml-compressed"
      "image/avif"
      "image/heic"
      "image/jxl"
    ];
  };
}

let
  imageViewers = [
    "brave-browser.desktop"
    "chromium-browser.desktop"
    "org.gnome.Shotwell-Viewer.desktop"
  ];
in
{
  "image/jpg" = imageViewers;
  "image/jpeg" = imageViewers;
  "image/png" = imageViewers;
  "image/gif" = imageViewers;
  "image/webp" = imageViewers;
  "image/tiff" = imageViewers;
  "image/x-tga" = imageViewers;
  "image/vnd-ms.dds" = imageViewers;
  "image/x-dds" = imageViewers;
  "image/bmp" = imageViewers;
  "image/vnd.microsoft.icon" = imageViewers;
  "image/vnd.radiance" = imageViewers;
  "image/x-exr" = imageViewers;
  "image/x-por" = imageViewers;
  "table-bitmap" = imageViewers;
  "image/x-portable-graymap" = imageViewers;
  "image/x-portable-pixmap" = imageViewers;
  "image/x-portable-anymap" = imageViewers;
  "image/x-qoi" = imageViewers;
  "image/svg+xml" = imageViewers;
  "image/svg+xml-compressed" = imageViewers;
  "image/avif" = imageViewers;
  "image/heic" = imageViewers;
  "image/jxl" = imageViewers;
}

{
  programs.yazi.settings.plugin.prepend_previewers = [
    {
      name = "*.md";
      run = "glow";
    }
    {
      mime = "binary/*";
      run = "hexyl";
    }
    {
      mime = "text/csv";
      run = "miller";
    }
    {
      mime = "audio/*";
      run = "exifaudio";
    }
    {
      mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}";
      run = "ouch";
    }
    {
      mime = "application/{,g}zip";
      run = "ouch";
    }
  ];
}

{
  prepend_previewers = [
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
      exec = "exifaudio";
    }
    {
      mime = "application/*zip";
      run = "ouch";
    }
    {
      mime = "application/x-tar";
      run = "ouch";
    }
    {
      mime = "application/x-bzip2";
      run = "ouch";
    }
    {
      mime = "application/x-7z-compressed";
      run = "ouch";
    }
    {
      mime = "application/x-rar";
      run = "ouch";
    }
    {
      mime = "application/x-xz";
      run = "ouch";
    }
    {
      on = ["f" "g"];
      run = "plugin fg";
      desc = "find file by content";
    }
    {
      on = ["f" "f"];
      run = "plugin fg --args='fzf'";
      desc = "find file by file name";
    }
  ];
}

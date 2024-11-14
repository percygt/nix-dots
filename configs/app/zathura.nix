{
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
    };
  };

  xdg.mimeApps.defaultApplications =
    let
      zathura = [ "org.pwmt.zathura.desktop" ];
    in
    {
      "application/epub+zip" = zathura;
      "application/pdf" = zathura;
      "application/oxps" = zathura;
      "application/x-fictionbook" = zathura;
    };
}

let
  zathura = [ "org.pwmt.zathura.desktop" ];
  assoc = {
    "application/epub+zip" = zathura;
    "application/pdf" = zathura;
    "application/oxps" = zathura;
    "application/x-fictionbook" = zathura;
  };
in
{
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
    };
  };

  xdg.mimeApps.defaultApplications = assoc;
  xdg.mimeApps.associations.added = assoc;
}

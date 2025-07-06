{
  xdg = {
    mime.defaultApplications = import ./mimeApps.nix;
    mime.addedAssociations = import ./mimeApps.nix;
  };
}

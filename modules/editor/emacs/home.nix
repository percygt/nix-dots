{ config, ... }:
let
  inherit (config._general) flakeDirectory;
  moduleEmacs = "${flakeDirectory}/modules/editor/emacs";
in
{
  xdg.desktopEntries = {
    emacs = {
      name = "Emacs";
      type = "Application";
      genericName = "Text Editor";
      exec = "emacs %F";
      terminal = false;
      icon = "emacs";
      comment = "Edit text";
      categories = [
        "Development"
        "TextEditor"
      ];
      startupNotify = true;
      settings = {
        StartupWMClass = "Emacs";
      };
      mimeType = [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
    };
  };
  xdg = {
    configFile = {
      "emacs/config".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/config";
      "emacs/early-init.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/early-init.el";
      "emacs/init.el".source = config.lib.file.mkOutOfStoreSymlink "${moduleEmacs}/init.el";
    };
  };
}

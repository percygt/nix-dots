{ lib, config, ... }:
let
  inherit (config._general) flakeDirectory;
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
  home = {
    activation = {
      linkEmacsConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        [ -e "${config.xdg.configHome}/emacs" ] || mkdir "${config.xdg.configHome}/emacs"
        [ -e "${config.xdg.configHome}/emacs/init.el" ] || ln -s "${flakeDirectory}/modules/editor/emacs/init.el" "${config.xdg.configHome}/emacs/init.el"
        [ -e "${config.xdg.configHome}/emacs/early-init.el" ] || ln -s "${flakeDirectory}/modules/editor/emacs/early-init.el" "${config.xdg.configHome}/emacs/early-init.el"
        [ -e "${config.xdg.configHome}/emacs/config" ] || ln -s "${flakeDirectory}/modules/editor/emacs/config" "${config.xdg.configHome}/emacs/config"
      '';
    };
  };
}

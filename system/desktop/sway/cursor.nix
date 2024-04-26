{
  libx,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    phinger-cursors
  ];
  programs.sway.extraSessionCommands = let
    cursorThemeInit = pkgs.writeShellApplication {
      name = "cursor-theme-init";
      runtimeInputs = with pkgs; [
        glib
        xorg.xsetroot
      ];
      text = ''
        xsetroot -cursor_name left_ptr
        export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas-44.0
        gsettings set org.gnome.desktop.interface cursor-theme '${libx.cursorTheme.name}'
        gsettings set org.gnome.desktop.interface cursor-size '${toString libx.cursorTheme.size}'
      '';
    };
  in
    lib.concatStringsSep "\n" [
      ''
        export XCURSOR_THEME='${libx.cursorTheme.name}'
        export XCURSOR_SIZE=${toString (builtins.floor (libx.cursorTheme.size * libx.cursorTheme.x-scaling))}
      ''
      cursorThemeInit
    ];
}

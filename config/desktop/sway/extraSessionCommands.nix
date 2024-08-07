{
  wayland.windowManager.sway.extraSessionCommands =
    # bash
    ''
      export SDL_VIDEODRIVER=wayland
      export XDG_CURRENT_DESKTOP=sway
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"

      # Automatically add electron/chromium wayland flags
      export NIXOS_OZONE_WL=1
      export _JAVA_AWT_WM_NONREPARENTING=1

      # Firefox wayland
      export MOZ_ENABLE_WAYLAND=1

      # XDG portal related variables (for screen sharing etc)
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=sway
    '';
}

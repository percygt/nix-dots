{
  config,
  lib,
  pkgs,
  libx,
  inputs,
  ...
}: let
  inherit (libx) wallpaper;
in {
  imports = [
    inputs.hypridle.homeManagerModules.default
    inputs.hyprlock.homeManagerModules.default
    ../rofi
    ../waybar
    ../mako.nix
    ../swappy.nix
    ../wl-common.nix
    ./hyprlock.nix
  ];
  nix.settings = {
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      "$mod" = "SUPER";

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 0;
      };

      dwindle = {
        preserve_split = true;
        force_split = 2;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
        workspace_swipe_invert = false;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 2;
        repeat_rate = 50;
        repeat_delay = 300;
      };

      decoration = {
        rounding = 8;
        drop_shadow = true;
        shadow_ignore_window = true;
        shadow_offset = "0 5";
        shadow_range = 50;
        shadow_render_power = 3;
        "col.shadow" = "rgba(00000099)";
      };

      animation = [
        "border, 1, 2, default"
        "fade, 1, 4, default"
        "windows, 1, 3, default, popin 80%"
        "workspaces, 1, 2, default, slide"
      ];

      misc = {
        # background_color = "rgb(${__substring 1 7 colours.surface1})";
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        animate_manual_resizes = true;
      };

      group = {
        groupbar = {
          font_family = "${config.gtk.iconTheme.name}";
          font_size = 12;
          gradients = true;
        };
      };

      xwayland = {
        force_zero_scaling = true;
      };
    };

    extraConfig = ''
      # terminal, screen locking, launcher
      bind = $mod, RETURN, exec, wezterm
      bind = $mod, L, exec, hyprlock
      bind = $mod, SPACE, exec, rofi -show drun
      bind = ALT, Q, killactive,

      # screenshots
      $screenshotarea = hyprctl keyword animation "fadeOut,0,0,default"; grimblast save area - | swappy -f -; hyprctl keyword animation "fadeOut,1,4,default"
      bind = , Print, exec, grimblast save output - | swappy -f -
      bind = SHIFT, Print, exec, grimblast save active - | swappy -f -
      bind = ALT, Print, exec, $screenshotarea

      # media controls
      bindl = , XF86AudioPlay, exec, playerctl play-pause
      bindl = , XF86AudioPrev, exec, playerctl previous
      bindl = , XF86AudioNext, exec, playerctl next

      # volume
      bindle = , XF86AudioRaiseVolume, exec, volumectl -u up
      bindle = , XF86AudioLowerVolume, exec, volumectl -u down
      bindl = , XF86AudioMute, exec, volumectl -u toggle-mute
      bindl = , XF86AudioMicMute, exec, volumectl -m toggle-mute
      bind = , Pause, exec, volumectl -m toggle-mute

      # backlight
      bindle = , XF86MonBrightnessUp, exec, lightctl up
      bindle = , XF86MonBrightnessDown, exec, lightctl down

      # apps
      bind = $mod, grave, exec, 1password --quick-access
      bind = $mod, C, exec, clipman pick -t rofi -T='-p Clipboard'

      # window controls
      bind = $mod, F, fullscreen,
      bind = $mod SHIFT, Space, togglefloating,
      bind = $mod, A, togglesplit,

      # override the split direction for the next window to be opened
      bind = $mod, V, layoutmsg, preselect d
      bind = $mod, H, layoutmsg, preselect r

      # group management
      bind = $mod, G, togglegroup,
      bind = $mod SHIFT, G, moveoutofgroup,
      bind = ALT, left, changegroupactive, b
      bind = ALT, right, changegroupactive, f

      # move focus
      bind = $mod, left, movefocus, l
      bind = $mod, right, movefocus, r
      bind = $mod, up, movefocus, u
      bind = $mod, down, movefocus, d

      # move window
      bind = $mod SHIFT, left, movewindoworgroup, l
      bind = $mod SHIFT, right, movewindoworgroup, r
      bind = $mod SHIFT, up, movewindoworgroup, u
      bind = $mod SHIFT, down, movewindoworgroup, d

      # window resize
      bind = $mod, R, submap, resize
      submap = resize
      binde = , right, resizeactive, 10 0
      binde = , left, resizeactive, -10 0
      binde = , up, resizeactive, 0 -10
      binde = , down, resizeactive, 0 10
      bind = , escape, submap, reset
      submap = reset

      # mouse bindings
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow

      # navigate workspaces
      bind = $mod, 1, workspace, 1
      bind = $mod, 2, workspace, 2
      bind = $mod, 3, workspace, 3
      bind = $mod, 4, workspace, 4
      bind = $mod, 5, workspace, 5
      bind = $mod, 6, workspace, 6
      bind = $mod, 7, workspace, 7
      bind = $mod, 8, workspace, 8
      bind = $mod, 9, workspace, 9

      # move window to workspace
      bind = $mod SHIFT, 1, movetoworkspace, 1
      bind = $mod SHIFT, 2, movetoworkspace, 2
      bind = $mod SHIFT, 3, movetoworkspace, 3
      bind = $mod SHIFT, 4, movetoworkspace, 4
      bind = $mod SHIFT, 5, movetoworkspace, 5
      bind = $mod SHIFT, 6, movetoworkspace, 6
      bind = $mod SHIFT, 7, movetoworkspace, 7
      bind = $mod SHIFT, 8, movetoworkspace, 8
      bind = $mod SHIFT, 9, movetoworkspace, 9
    '';
  };

  home.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

  systemd.user.services.swaybg = {
    Unit.Description = "swaybg";
    Install.WantedBy = ["hyprland-session.target"];
    Service = {
      Type = "simple";
      ExecStart = "${lib.getExe pkgs.swaybg} -m fill -i ${wallpaper}";
      Restart = "on-failure";
    };
  };
}

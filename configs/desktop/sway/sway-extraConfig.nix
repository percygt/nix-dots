{
  wayland.windowManager.sway.extraConfig = ''
    shadows enable
    blur enable
    blur_radius 7
    blur_passes 4
    blur_noise 0.1
    corner_radius 12
    scratchpad_minimize enable
    bindgesture swipe:4:right workspace prev
    bindgesture swipe:4:left workspace next
    bindgesture swipe:3:right focus left
    bindgesture swipe:3:left focus right
    bindswitch lid:off output * power off
    exec sleep 2 && exec swaymsg "workspace 2; exec brave --profile-directory=\"DevCtl\""
    exec sleep 8 && exec swaymsg "workspace 1; exec brave --profile-directory=\"Default\""
  '';
}

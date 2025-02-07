{
  wayland.windowManager.sway.extraConfig = ''
    shadows enable
    blur enable
    blur_radius 7
    blur_passes 4
    blur_noise 0.05
    corner_radius 12
    scratchpad_minimize enable
    bindgesture swipe:4:right workspace prev
    bindgesture swipe:4:left workspace next
    bindgesture swipe:3:right focus left
    bindgesture swipe:3:left focus right
    bindswitch lid:off output * power off
    exec --no-startup-id swaymsg "workspace 2; exec brave --profile-directory=\"DevCtl\""
    exec --no-startup-id swaymsg "workspace 1; exec brave --profile-directory=\"Default\""
  '';
}

{
  extraConfig = ''
    shadows enable
    blur_radius 7
    blur_passes 4
    corner_radius 10
    smart_corner_radius enable
    default_dim_inactive 0.2
    layer_effects "waybar" "blur enable"; shadows enable

    bindgesture swipe:4:right workspace prev
    bindgesture swipe:4:left workspace next
    bindgesture swipe:3:right focus left
    bindgesture swipe:3:left focus right
    bindswitch lid:off output * power off

    # for_window [sticky] dim_inactive 0

    for_window [title=".*"] inhibit_idle fullscreen

    exec sleep 2 && exec swaymsg "workspace 3; exec brave --profile-directory=\"Profile 1\""
    exec sleep 8 && exec swaymsg "workspace 1; exec brave --profile-directory=\"Default\""
    # exec sleep 12 && exec swaymsg "workspace 2; exec i3-quickterm shell"
  '';
}

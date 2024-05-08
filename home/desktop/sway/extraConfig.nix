{
  extraConfig = ''
    shadows enable
    blur_radius 4
    blur_passes 2
    blur enable
    corner_radius 5
    default_dim_inactive 0.3
    scratchpad_minimize enable
    layer_effects "waybar" "blur enable; shadows enable; corner_radius 5"
    bindgesture swipe:4:right workspace prev
    bindgesture swipe:4:left workspace next
    bindgesture swipe:3:right focus left
    bindgesture swipe:3:left focus right
    bindswitch lid:off output * power off

    exec sleep 2 && exec swaymsg "workspace 3; exec brave --profile-directory=\"Profile 1\""
    exec sleep 8 && exec swaymsg "workspace 2; exec brave --profile-directory=\"Default\""
  '';
}

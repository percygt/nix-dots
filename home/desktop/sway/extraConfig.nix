{
  extraConfig = ''
    bindgesture swipe:4:right workspace prev
    bindgesture swipe:4:left workspace next
    bindgesture swipe:3:right focus left
    bindgesture swipe:3:left focus right
    bindswitch lid:off output * power off

    for_window [title=".*"] inhibit_idle fullscreen
    for_window [class=com.bitwig.BitwigStudio] inhibit_idle focus
    for_window [app_id=nmtui] floating enable, resize set width 80 ppt height 80 ppt, move position center
    for_window [app_id=qalculate-gtk] floating enable, move position center
    for_window [app_id=org.gnome.Calculator] floating enable, move position center
    for_window [app_id=\.?blueman-manager(-wrapped)?] floating enable, resize set width 80 ppt height 80 ppt, move position center
    for_window [app_id=nixos_rebuild_log] floating enable, resize set width 80 ppt height 80 ppt, move position center
    for_window [app_id=btop] floating enable, resize set width 80 ppt height 80 ppt, move position center
    for_window [app_id=pavucontrol] floating enable, resize set width 80 ppt height 80 ppt, move position center
    for_window [app_id=org.rncbc.qpwgraph] floating enable, resize set width 80 ppt height 80 ppt, move position center
    for_window [app_id=nnn] floating enable, resize set width 80 ppt height 80 ppt, move position center
    for_window [app_id=gnome-disks] floating enable, resize set width 80 ppt height 80 ppt, move position center
    for_window [app_id=audacious] floating enable, resize set width 80 ppt height 80 ppt, move position center
    for_window [app_id=org.gnome.Weather] floating enable, resize set width 40 ppt height 50 ppt, move position center

    exec sleep 2 && exec swaymsg "workspace 3; exec brave --profile-directory=\"Profile 1\""
    exec sleep 8 && exec swaymsg "workspace 2; exec brave --profile-directory=\"Default\""
  '';
}

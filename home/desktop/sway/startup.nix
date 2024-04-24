{pkgs, ...}: {
  startup = [
    {command = "${pkgs.dbus}/bin/dbus-update-activation-environment WAYLAND_DISPLAY";}
    {command = "${pkgs.gnome.nautilus}/bin/nautilus";}
    # {command = "brave --profile-directory='Default'";}
    # {command = "${config.home.homeDirectory}/.nix-profile/bin/brave --class brave-dev --profile-directory='Profile 1'";}
    {command = "${pkgs.keepassxc}/bin/keepassxc";}
    {command = "${pkgs.stash.wezterm_nightly}/bin/wezterm";}
    {command = "${pkgs.i3-quickterm}/bin/i3-quickterm shell";}
    {
      command = "${pkgs.mako}/bin/mako";
    }
    {command = "tmux kill-server";}
    {
      command = "systemctl --user restart waybar.service";
      always = true;
    }
    {
      command = "systemctl --user restart kanshi";
      always = true;
    }
    {
      command = "${pkgs.sway-contrib.inactive-windows-transparency}/bin/inactive-windows-transparency.py --opacity 0.75";
      always = true;
    }
  ];
}

{ inputs, pkgs, ... }: {
  # XDG portal
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  services.xserver = { displayManager.startx.enable = true; };
  security = { polkit.enable = true; };

  # Enabling hyprlnd on NixOS
  programs.hyprland = {
    enable = true;
    nvidiaPatches = true;
    xwayland.enable = true;
  };

}

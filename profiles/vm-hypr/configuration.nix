{pkgs, ...}: {
  imports = [
    ./hardware.nix
    ./disks.nix
    ./boot.nix
  ];

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
  };
  # XDG portal
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  services.xserver = {displayManager.startx.enable = true;};

  infosec = {
    sops.enable = true;
  };
  core = {
    zram.enable = true;
    bootmanagement.enable = true;
    ntp.enable = true;
    storage.enable = true;
    # audioengine.enable = true;
    systemd.enable = true;
    graphics.enable = true;
    packages.enable = true;
  };

  # Enabling hyprlnd on NixOS
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
}

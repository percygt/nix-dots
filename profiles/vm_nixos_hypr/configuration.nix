{
  listSystemImports,
  pkgs,
  ...
}: let
  modules = [
    "."
    # "desktop"
  ];
in {
  imports =
    listSystemImports modules
    ++ [
      # inputs.home-manager.nixosModules.default
      ./hardware.nix
      ./disks.nix
      ./boot.nix
    ];

  # XDG portal
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  services.xserver = {displayManager.startx.enable = true;};

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

{inputs, ...}: {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
  # enable hyprland and required options
  programs.hyprland.enable = true;
}

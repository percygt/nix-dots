{
  desktop,
  pkgs,
  ...
}: {
  imports = [
    (./. + "/${desktop}.nix")
    ../services/pipewire.nix
    ../extra/fonts.nix
  ];

  # Enable Plymouth and surpress some logs by default.
  boot.plymouth = {
    enable = true;
    themePackages = [(pkgs.catppuccin-plymouth.override {variant = "mocha";})];
    theme = "catppuccin-mocha";
  };
  
  boot.kernelParams = [
    # The 'splash' arg is included by the plymouth option
    "quiet"
    "loglevel=3"
    "rd.udev.log_priority=3"
    "vt.global_cursor_default=0"
  ];

  hardware.opengl.enable = true;

  # Enable location services
  location.provider = "geoclue2";
}

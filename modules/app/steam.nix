{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    # Enable Steam Input for controller support
    # package = pkgs.steam.override {
    #   extraPkgs =
    #     pkgs: with pkgs; [
    #       # Controller support libraries
    #       libusb1
    #       udev
    #       SDL2
    #
    #       # Additional libraries for better compatibility
    #       xorg.libXcursor
    #       xorg.libXi
    #       xorg.libXinerama
    #       xorg.libXScrnSaver
    #       xorg.libXcomposite
    #       xorg.libXdamage
    #       xorg.libXrender
    #       xorg.libXext
    #
    #       # Fix for Xwayland symbol errors
    #       libkrb5
    #       keyutils
    #     ];
    # };
  };

  environment.systemPackages = with pkgs; [
    steam-run
    mangohud
  ];
  persistHome.directories = [
    ".local/share/Steam"
    ".steam"
  ];
}

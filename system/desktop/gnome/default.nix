{pkgs, ...}: {
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    displayManager.autoLogin.enable = false;
    desktopManager.gnome.enable = true;
  };
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gedit # text editor
      epiphany # web browser
      geary # email reader
      gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      yelp # Help view
      gnome-contacts
      gnome-initial-setup
    ]);

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
  ];

  services.gnome.gnome-keyring.enable = true;

  programs.dconf.enable = true;
}

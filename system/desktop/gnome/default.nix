{pkgs, ...}: {
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    displayManager.autoLogin.enable = false;
    desktopManager.gnome.enable = true;
    libinput.enable = true;
    libinput.touchpad.tapping = true; #tap
  };
  # Flatpak
  # services.flatpak.enable = true;
  # locate
  # services.locate.enable = true;
  # Enable CUPS to print documents.
  # services.printing.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # systemd = {
  #   user.services.polkit-gnome-authentication-agent-1 = {
  #     description = "polkit-gnome-authentication-agent-1";
  #     wantedBy = ["graphical-session.target"];
  #     wants = ["graphical-session.target"];
  #     after = ["graphical-session.target"];
  #     serviceConfig = {
  #       Type = "simple";
  #       ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #       Restart = "on-failure";
  #       RestartSec = 1;
  #       TimeoutStopSec = 10;
  #     };
  #   };
  # };

  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
      gedit # text editor
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
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
    phinger-cursors
  ];

  services.gnome.gnome-keyring.enable = true;

  programs.dconf.enable = true;
}

{ pkgs, config, ... }:
let
  t = config.modules.themes.gnomeShellTheme;
in
{
  services = {
    flatpak.enable = true;
    locate.enable = true;
    printing.enable = true;
    gvfs.enable = true;
    sushi.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      evolution-data-server.enable = true;
      glib-networking.enable = true;
      gnome-online-accounts.enable = true;
    };
    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      displayManager.autoLogin.enable = false;
      desktopManager.gnome.enable = true;
      libinput.enable = true;
      libinput.touchpad.tapping = true; # tap
    };
  };

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

  environment.systemPackages = [
    pkgs.gnome.gnome-tweaks
    t.package
    pkgs.phinger-cursors
  ];

  programs.dconf.enable = true;
}

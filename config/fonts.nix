{
  interface = {
    name = "Geist";
    style = "Regular";
    weight = "500";
    package = pkgs: pkgs.geist-font;
    size = 14.0;
  };

  icon = {
    name = "Font Awesome 6 Free";
    style = "Regular";
    weight = "400";
    package = pkgs: pkgs.font-awesome;
    size = 12.0;
  };

  shell = {
    name = "VictorMono Nerd Font Propo";
    style = "SemiBold";
    weight = "600";
    package = pkgs: pkgs.nerdfonts;
    size = 14.0;
  };

  packages =
    pkgs: with pkgs; [
      nerdfonts
      nerdfonts-fontconfig
      google-fonts
      (iosevka-bin.override { variant = "Aile"; })
      (iosevka-bin.override { variant = "Etoile"; })
      emacs-all-the-icons-fonts
      source-serif
      rubik
      inter
      geist-font
      work-sans
      noto-fonts
      noto-fonts-cjk
      joypixels
      noto-fonts-emoji
      font-awesome

      corefonts
      vistafonts
      ubuntu_font_family
    ];
}

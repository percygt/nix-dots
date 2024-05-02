{
  interface = {
    name = "Rubik";
    style = "Regular";
    weight = "400";
    package = pkgs: pkgs.rubik;
    size = 12.0;
  };

  icon = {
    name = "Font Awesome 6 Free";
    style = "Regular";
    weight = "400";
    package = pkgs: pkgs.font-awesome;
    size = 12.0;
  };

  shell = {
    name = "VictorMono Nerd Font";
    style = "SemiBold";
    weight = "600";
    package = pkgs: pkgs.nerdfonts.override {fonts = ["VictorMono"];};
    size = 14.0;
  };

  packages = pkgs:
    with pkgs; [
      (nerdfonts.override {
        fonts = [
          "VictorMono"
          "JetBrainsMono"
          "MartianMono"
          "GeistMono"
        ];
      })
      # martian-mono
      source-serif
      rubik
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

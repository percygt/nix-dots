{
  interface = {
    name = "Rubik";
    package = pkgs: pkgs.rubik;
    size = 12;
  };

  shell = {
    name = "VictorMono Nerd Font";
    package = pkgs: pkgs.nerdfonts.override {fonts = ["VictorMono"];};
    size = 14;
  };

  console = {
    name = "JetBrainsMono Nerd Font";
    package = pkgs: pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
    size = 14;
  };

  packages = pkgs:
    with pkgs; [
      (nerdfonts.override {
        fonts = [
          "VictorMono"
          "JetBrainsMono"
        ];
      })
      martian-mono
      source-serif
      rubik
      work-sans
      noto-fonts
      noto-fonts-cjk
      joypixels
      noto-fonts-emoji

      corefonts
      vistafonts
      ubuntu_font_family
    ];
}

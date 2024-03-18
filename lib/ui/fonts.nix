{
  interface = {
    name = "Rubik";
    package = pkgs: pkgs.rubik;
    size = 10;
  };

  shell = {
    name = "VictorMono Nerd Font";
    package = pkgs: pkgs.nerdfonts.override {fonts = ["VictorMono"];};
    size = 10;
  };

  console = {
    name = "Martian Mono";
    package = pkgs: pkgs.martian-mono;
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

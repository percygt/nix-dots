rec {
  default = {
    interface = {
      name = "Rubik";
      package = pkgs: pkgs.rubik;
      size = 10;
      type = "serif";
    };
    shell = {
      name = "VictorMono Nerd Font";
      package = pkgs: pkgs.nerdfonts.override {fonts = ["VictorMono"];};
      size = 10;
      type = "monospace";
    };
    console = {
      name = "Martian Mono";
      package = pkgs: pkgs.martian-mono;
      size = 14;
      type = "monospace";
    };
  };

  packages = pkgs:
    (system.serif.packages pkgs)
    ++ (system.sansSerif.packages pkgs)
    ++ (system.monospace.packages pkgs)
    ++ (system.emoji.packages pkgs)
    ++ (system.extra.packages pkgs);
  system = {
    serif = {
      names = [
        "Source Serif"
      ];
      packages = pkgs:
        with pkgs; [
          source-serif
        ];
    };

    sansSerif = {
      names = [
        "Work Sans"
      ];
      packages = pkgs: [
        pkgs.work-sans
      ];
    };
    monospace = {
      names = [
        "JetBrainsMono Nerd Font"
      ];
      packages = pkgs:
        with pkgs; [
          (nerdfonts.override {
            fonts = [
              "JetBrainsMono"
            ];
          })
        ];
    };
    emoji = {
      names = [
        "Joypixels"
        "Noto Color Emoji"
      ];
      packages = pkgs:
        with pkgs; [
          joypixels
          noto-fonts-emoji
        ];
    };
    extra = {
      packages = pkgs:
        with pkgs; [
          corefonts
          vistafonts
          ubuntu_font_family
          noto-fonts
          noto-fonts-cjk
        ];
    };
  };
}

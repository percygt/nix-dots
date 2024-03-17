{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    rubik
    martian-mono
    (nerdfonts.override {
      fonts = [
        "VictorMono"
        "JetBrainsMono"
      ];
    })
    corefonts
    vistafonts
    ubuntu_font_family
    noto-fonts
    noto-fonts-cjk
  ];
}

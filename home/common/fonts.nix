{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    rubik
    (nerdfonts.override {
      fonts = [
        "VictorMono"
        "JetBrainsMono"
        "Hack"
      ];
    })
  ];
}

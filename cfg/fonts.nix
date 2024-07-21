{ pkgs, ... }:
{
  setFonts = {
    shell = {
      name = "VictorMono Nerd Font Propo";
      style = "SemiBold";
      typeface = "monospace";
      size = 14.0;
    };
    interface = {
      name = "Geist";
      style = "Regular";
      typeface = "sansSerif";
      package = pkgs.geist-font;
      size = 14.0;
    };
    icon = {
      name = "Font Awesome 6 Free";
      style = "Regular";
      package = pkgs.font-awesome;
      size = 12.0;
    };
    nerdfontPackages = pkgs.nerdfonts.override {
      fonts = [
        "VictorMono"
        "JetBrainsMono"
        "MartianMono"
        "GeistMono"
        "Monaspace"
        "Iosevka"
        "NerdFontsSymbolsOnly"
      ];
    };
    extraFontPackages = with pkgs; [
      (iosevka-bin.override { variant = "Aile"; })
      (iosevka-bin.override { variant = "Etoile"; })
      emacs-all-the-icons-fonts
    ];
  };
}

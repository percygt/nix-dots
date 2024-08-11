{ pkgs, ... }:
{
  modules.fonts = {
    shell = {
      name = "VictorMono NFP";
      style = [
        "SemiBold"
        "Bold"
        "SemiBold Italic"
        "Bold Italic"
      ];
      typeface = "monospace";
      size = 14.0;
    };
    interface = {
      name = "Iosevka Aile";
      typeface = "sansSerif";
      package = pkgs.iosevka-bin.override { variant = "Aile"; };
      size = 14.0;
    };
    app = {
      name = "Geist";
      typeface = "sansSerif";
      package = pkgs.geist-font;
      size = 12.0;
    };
    icon = {
      name = "Font Awesome 6 Free";
      package = pkgs.font-awesome;
      size = 12.0;
    };
    extraFonts = with pkgs; [
      (iosevka-bin.override { variant = "Aile"; })
      emacs-all-the-icons-fonts
    ];
    nerdfontPackages = pkgs.nerdfonts.override {
      fonts = [
        "VictorMono"
        "JetBrainsMono"
        "Iosevka"
        "NerdFontsSymbolsOnly"
      ];
    };
  };
}

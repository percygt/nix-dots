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
      name = "0xProto Nerd Font";
      typeface = "monospace";
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
    nerdfontPackages = pkgs.nerdfonts.override {
      fonts = [
        "VictorMono"
        "JetBrainsMono"
        "Iosevka"
        "0xProto"
        "NerdFontsSymbolsOnly"
      ];
    };
  };
}

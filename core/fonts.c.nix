{ pkgs, ... }:
{
  modules.fonts = {
    shell = {
      name = "VictorMono Nerd Font";
      style = [
        "SemiBold"
        "Bold"
        "Italic"
        "Bold Italic"
      ];
      package = pkgs.nerd-fonts.victor-mono;
      typeface = "monospace";
      size = 11.0;
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
    extraFonts =
      (with pkgs; [
        (iosevka-bin.override { variant = "Aile"; })
        cryptofont
        emacs-all-the-icons-fonts
        noto-fonts
        noto-fonts-cjk-sans
        corefonts
        vistafonts
        open-sans
        source-sans-pro
        source-serif
        noto-fonts-emoji
        ubuntu_font_family
      ])
      ++ (with pkgs.nerd-fonts; [
        monaspace
        geist-mono
        jetbrains-mono
        symbols-only
      ]);
  };
}

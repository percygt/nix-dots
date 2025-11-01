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
      package = pkgs.unstable.nerd-fonts.victor-mono;
      typeface = "monospace";
      size = 11.0;
    };
    propo = {
      name = "IosevkaTerm Nerd Font Propo";
      package = pkgs.unstable.nerd-fonts.iosevka-term;
      typeface = "monospace";
      size = 14.0;
    };
    interface = {
      name = "Iosevka Aile";
      typeface = "sansSerif";
      package = pkgs.unstable.iosevka-bin.override { variant = "Aile"; };
      size = 12.0;
    };
    app = {
      name = "Geist";
      typeface = "sansSerif";
      package = pkgs.unstable.geist-font;
      size = 12.0;
    };
    icon = {
      name = "Symbols Nerd Font";
      package = pkgs.unstable.nerd-fonts.symbols-only;
      size = 12.0;
    };
    extraFonts =
      (with pkgs; [
        (iosevka-bin.override { variant = "Aile"; })
        cryptofont
        noto-fonts-tagalog-sans
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
      ++ (with pkgs.unstable.nerd-fonts; [
        iosevka-term
        monaspace
        geist-mono
        jetbrains-mono
        symbols-only
      ]);
  };
}

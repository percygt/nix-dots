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
    propo = {
      name = "IosevkaTerm Nerd Font Propo";
      package = pkgs.nerd-fonts.iosevka-term;
      typeface = "monospace";
      size = 14.0;
    };
    interface = {
      name = "Iosevka Aile";
      typeface = "sansSerif";
      package = pkgs.iosevka-bin.override { variant = "Aile"; };
      size = 12.0;
    };
    app = {
      name = "Geist";
      typeface = "sansSerif";
      package = pkgs.geist-font;
      size = 12.0;
    };
    icon = {
      name = "Symbols Nerd Font";
      package = pkgs.nerd-fonts.symbols-only;
      size = 12.0;
    };
    extraFonts =
      (with pkgs; [
        (iosevka-bin.override { variant = "Aile"; })
        # cryptofont
        aporetic
        noto-fonts-tagalog-sans
        emacs-all-the-icons-fonts
        noto-fonts
        noto-fonts-cjk-sans
        corefonts
        vista-fonts # vistafonts
        open-sans
        source-sans-pro
        source-serif
        maple-mono.NF
        noto-fonts-color-emoji # noto-fonts-emoji
        ubuntu-classic # ubuntu_font_family
      ])
      ++ (with pkgs.nerd-fonts; [
        iosevka-term
        zed-mono
        monaspace
        geist-mono
        jetbrains-mono
        symbols-only
      ]);
  };
}

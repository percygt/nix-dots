{pkgs, ...}: {
  nixpkgs.config.joypixels.acceptLicense = true;
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;
    packages = with pkgs; [
    
    (nerdfonts.override {
      fonts = [
        "VictorMono"
        "JetBrainsMono"
        "Hack"
      ];
    })
      rubik
      corefonts
      vistafonts
      source-serif
      work-sans
      joypixels
      noto-fonts-emoji
      ubuntu_font_family
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];

    fontconfig = {
      antialias = true;
      defaultFonts = {
        serif = ["Source Serif"];
        sansSerif = ["Rubik" "Work Sans"];
        monospace = ["VictorMono Nerd Font" "JetBrainsMono Nerd Font" "Hack Nerd Font Mono"];
        emoji = ["Joypixels" "Noto Color Emoji"];
      };
      enable = true;
      hinting = {
        autohint = false;
        enable = true;
        style = "slight";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "light";
      };
    };
  };
}

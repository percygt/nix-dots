{pkgs, ...}: rec {
  ui = {
    name = builtins.elemAt sansSerif.names 0; # Rubik
    package = builtins.elemAt sansSerif.packages 0;
    size = 10;
  };
  shell = {
    name = builtins.elemAt monospace.names 1; # VictorMono Nerd Font
    package = builtins.elemAt monospace.packages 1;
    size = 14;
  };
  console = {
    name = builtins.elemAt monospace.names 2; # Martian Mono
    package = builtins.elemAt monospace.packages 2;
    size = 10;
  };
  packages = serif.packages ++ sansSerif.packages ++ monospace.packages ++ emoji.packages ++ extra.packages;
  serif = {
    names = [
      "Source Serif"
    ];
    packages = with pkgs; [
      source-serif
    ];
  };
  sansSerif = {
    names = [
      "Rubik"
      "Work Sans"
    ];
    packages = with pkgs; [
      rubik
      work-sans
    ];
  };
  monospace = {
    names = [
      "JetBrainsMono Nerd Font"
      "VictorMono Nerd Font"
      "Martian Mono"
    ];
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
        ];
      })
      (nerdfonts.override {
        fonts = [
          "VictorMono"
        ];
      })
      martian-mono
    ];
  };
  emoji = {
    names = [
      "Joypixels"
      "Noto Color Emoji"
    ];
    packages = with pkgs; [
      joypixels
      noto-fonts-emoji
    ];
  };
  extra = {
    packages = with pkgs; [
      corefonts
      vistafonts
      ubuntu_font_family
      noto-fonts
      noto-fonts-cjk
    ];
  };
}

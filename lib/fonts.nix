{pkgs, ...}: {
  fonts = {
    default = {
      name = "Inter";
      package = pkgs.inter;
      size = "10";
    };
    iconFont = {
      name = "Inter";
      package = pkgs.inter;
    };
    monospace = {
      name = "MesloLGSDZ Nerd Font Mono";
      package = pkgs.nerdfonts.override {fonts = ["Meslo"];};
    };
    emoji = {
      name = "Joypixels";
      package = pkgs.joypixels;
    };
  };
}

{pkgs, ...}: {
  console = {
    earlySetup = true;
    packages = with pkgs; [terminus_font powerline-fonts];
    font = "ter-powerline-v32n";
  };

  services.kmscon = {
    enable = true;
    hwRender = true;
    fonts = [
      {
        name = "MesloLGSDZ Nerd Font Mono";
        package = pkgs.nerdfonts.override {fonts = ["Meslo"];};
      }
    ];
    extraConfig = ''
      font-size=14
      xkb-layout=us
    '';
  };
}

{
  pkgs,
  self,
  config,
  ...
}: let
  inherit (import "${self}/lib/mkUI.nix" {inherit config pkgs;}) fonts;
in {
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
        inherit (fonts.console) name package;
      }
    ];
    extraConfig = ''
      font-size=${builtins.toString fonts.console.size}
      xkb-layout=us
    '';
  };
}

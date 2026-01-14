{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.modules.app.gaming.enable {
    programs.steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    environment.systemPackages = with pkgs; [
      steam-run
      mangohud
      bottles

      (lutris.override {
        extraPkgs = pkgs: [
          pkgs.wineWowPackages.stagingFull
          pkgs.winetricks
        ];
      })
    ];
    persistHome.directories = [
      ".local/share/Steam"
      ".local/share/bottles"
      ".steam"
    ];
  };
}

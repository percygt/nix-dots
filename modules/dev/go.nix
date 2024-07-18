{ lib, config, ... }:
{
  config = lib.mkIf config.dev.home.enable {
    programs.go = {
      enable = true;
      goPath = ".local/share/go";
      goBin = ".local/share/go/bin";
    };
  };
}

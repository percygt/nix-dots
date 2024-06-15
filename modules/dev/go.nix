{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.dev.home.enable {
    programs.go = {
      enable = true;
      goPath = "${config.xdg.configHome}/go";
    };
  };
}

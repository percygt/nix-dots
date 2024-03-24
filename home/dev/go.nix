{config, ...}: {
  programs.go = {
    enable = true;
    goPath = "${config.xdg.configHome}/go";
  };
}

{
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = {
        strict_env = true;
        warn_timeout = "30s";
      };
    };
  };
}

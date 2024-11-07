{
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
      config = {
        global = {
          strict_env = true;
          warn_timeout = "1m";
        };
      };
    };
  };

  # Suppress direnv's verbose output
  # https://github.com/direnv/direnv/issues/68#issuecomment-42525172
  home.sessionVariables.DIRENV_LOG_FORMAT = "";
}

{flakeDirectory, ...}: {
  home.sessionVariables = {
    FLAKE_PATH = flakeDirectory;
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
  };
}

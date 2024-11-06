{
  config,
  ...
}:
let
  inherit (config._base) flakeDirectory;
in
{
  home.sessionVariables = {
    FLAKE = flakeDirectory;
    MANPAGER = "nvim +Man!";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    # Suppress direnv's verbose output
    # https://github.com/direnv/direnv/issues/68#issuecomment-42525172
    DIRENV_LOG_FORMAT = "";
  };
}
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.modules.dev.gh.enable {
    home.packages = [ pkgs.gh-dash ];
    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
      };
    };
  };
}

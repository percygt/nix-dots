{
  config,
  lib,
  ...
}:
let
  gitsigning = config.modules.dev.gitsigning.enable;
in
{
  config = lib.mkIf (config.modules.dev.gh.enable && gitsigning) {
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

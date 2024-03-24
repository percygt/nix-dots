{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.percygt.git.enable {
    programs.gh = {
      enable = true;
      extensions = with pkgs; [
        gh-eco
        gh-dash
        gh-actions-cache
      ];
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

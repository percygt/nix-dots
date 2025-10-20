{
  pkgs,
  config,
  lib,
  ...
}:
let
  g = config._global;
  gh_http_repo = "https://github.com/percygt/";
  glab_http_repo = "https://gitlab.com/percygt/";
  gh_ssh_repo = "ssh://git@github.com/percygt/";
  glab_ssh_repo = "ssh://git@gitlab.com/percygt/";
  codebox = {
    vcs = "git";
    root = "${g.dataDirectory}/codebox";
  };
in
{
  config = lib.mkIf config.modules.dev.ghq.enable {
    home.packages = with pkgs; [ ghq ];
    programs.git.extraConfig.ghq = {
      vcs = "git";
      root = "${g.dataDirectory}/git-repo";
      ${glab_ssh_repo} = codebox;
      ${gh_ssh_repo} = codebox;
      ${glab_http_repo} = codebox;
      ${gh_http_repo} = codebox;
    };
  };
}

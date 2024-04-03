{
  pkgs,
  config,
  lib,
  ...
}: let
  gh_http_repo = "https://github.com/percygt/";
  glab_http_repo = "https://gitlab.com/percygt/";
  gh_ssh_repo = "ssh://git@github.com/percygt/";
  glab_ssh_repo = "ssh://git@gitlab.com/percygt/";
  codebox = {
    vcs = "git";
    root = "${config.home.homeDirectory}/data/codebox";
  };
in {
  config = lib.mkIf config.userModules.git.ghq.enable {
    home.packages = with pkgs; [
      ghq
    ];
    programs.git.extraConfig.ghq = {
      vcs = "git";
      root = "${config.home.homeDirectory}/data/git-repo";
      ${glab_ssh_repo} = codebox;
      ${gh_ssh_repo} = codebox;
      ${glab_http_repo} = codebox;
      ${gh_http_repo} = codebox;
    };
  };
}

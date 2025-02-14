{
  config,
  pkgs,
  lib,
  ...
}:
let
  g = config._base;
in
{
  home.packages = [ pkgs.glab ];
  sops.secrets = {
    "git/glab-cli/config.yml" = {
      path = "${config.xdg.configHome}/glab-cli/config.yml";
      mode = "0600";
    };
  };
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
  programs.git = {
    enable = true;
    userName = "Percy Timon";
    userEmail = "percygt.dev@gmail.com";
    lfs.enable = true;
    extraConfig = {
      core.editor = "nvim";
      init.defaultBranch = "main";
      safe.directory = "${g.flakeDirectory}";
      pull.rebase = false;
      color.ui = true;
      column.ui = "auto";
      diff.colorMoved = "zebra";
      fetch.prune = true;
      merge.conflictstyle = "diff3";
      push.autoSetupRemote = true;
      push.default = "current";
      rebase = {
        autosquash = true;
        updateRefs = true;
      };
      rerere.enabled = true;
      tag.sort = "version:refname";
      branch.sort = "-committerdate";
      maintenance.auto = false;
      maintenance.strategy = "incremental";
      submodule.recurse = "true";
      checkout.defaultRemote = "origin";
    };

    signing = {
      signByDefault = true;
      format = "openpgp";
      key = g.security.gpg.signingKey;
      signer = lib.getExe g.security.gpg.package;
    };
  };
}

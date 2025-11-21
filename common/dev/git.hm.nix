{
  config,
  ...
}:
let
  g = config._global;
in
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
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
  };
}

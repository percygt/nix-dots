{
  config,
  lib,
  ...
}: {
  options = {
    userModules.git.enable =
      lib.mkEnableOption "Enable git";
  };
  config = lib.mkIf config.userModules.git.enable {
    programs.git = {
      enable = true;
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
        color.ui = true;
        column.ui = "auto";
        diff.colorMoved = "zebra";
        fetch.prune = true;
        merge.conflictstyle = "diff3";
        push.autoSetupRemote = true;
        rebase.autoStash = true;
        rerere.enabled = true;
        branch.sort = "-committerdate";
        core.compression = 0;
      };
      lfs = {enable = true;};

      delta = import ./delta.nix;

      aliases = import ./gitaliases.nix;

      ignores = import ./gitignores.nix;
    };
  };
}

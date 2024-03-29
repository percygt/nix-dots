{config, ...}: {
  imports = [
    ./gh.nix
    ./glab.nix
    ./ghq.nix
    ./credentials.nix
  ];
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
      maintenance.auto = false;
      maintenance.strategy = "incremental";
      include = {
        path = "${config.home.homeDirectory}/.config/git/credentials";
      };
    };
    lfs = {enable = true;};

    delta = import ./delta.nix;

    aliases = import ./gitaliases.nix;

    ignores = import ./gitignores.nix;

    signing = {
      signByDefault = true;
      key = "1F3DB564F0E44F81!";
    };
  };
}

{
  config,
  lib,
  ...
}: {
  imports = [
    ./gh.nix
    ./glab.nix
    ./credentials.nix
  ];
  options = {
    userModules.git = {
      enable =
        lib.mkEnableOption "Enable git";
      credentials.enable = lib.mkEnableOption "Enable git credentials";
      glab.enable = lib.mkEnableOption "Enable git credentials";
      gh.enable = lib.mkEnableOption "Enable gh";
    };
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
        maintenance.auto = false;
        maintenance.strategy = "incremental";
        include = lib.mkIf config.userModules.git.credentials.enable {
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
  };
}

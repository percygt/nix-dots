{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./ghq.nix];

  config = lib.mkIf config.dev.home.enable {
    home.packages = [pkgs.glab];
    sops.secrets = {
      "git/glab-cli/config.yml" = {
        path = "${config.xdg.configHome}/glab-cli/config.yml";
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

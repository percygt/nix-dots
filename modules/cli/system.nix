{
  lib,
  config,
  libx,
  ...
}:
let
  g = config._general;
  inherit (libx) enableDefault inheritModule;
  inheritCli =
    module:
    inheritModule {
      inherit module config;
      name = "cli";
    };
in
{
  options.modules.cli = {
    atuin.enable = enableDefault "atuin";
    direnv.enable = enableDefault "direnv";
    extra.enable = enableDefault "extra";
    starship.enable = enableDefault "starship";
    aria.enable = enableDefault "aria";
    ncmpcpp.enable = enableDefault "ncmpcpp";
    yazi.enable = enableDefault "yazi";
    common.enable = enableDefault "common";
    bat.enable = enableDefault "bat";
    eza.enable = enableDefault "eza";
    tmux.enable = enableDefault "tmux";
    nixtools.enable = enableDefault "nixtools";
  };
  config = lib.mkMerge [
    {
      home-manager.users.${g.username} = import ./home.nix;
      environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
        "/persist".users.${g.username}.directories = [
          ".local/share/atuin"
          ".local/share/aria2"
          ".local/share/tmux"
          ".local/share/navi"
          ".local/share/zoxide"
        ];
      };
    }
    (inheritCli "atuin")
    (inheritCli "aria")
    (inheritCli "tmux")
    (inheritCli "common")
    (inheritCli "direnv")
    (inheritCli "extra")
    (inheritCli "starship")
    (inheritCli "ncmpcpp")
    (inheritCli "yazi")
    (inheritCli "bat")
    (inheritCli "eza")
    (inheritCli "nixtools")
  ];
}

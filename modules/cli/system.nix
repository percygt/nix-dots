{
  lib,
  config,
  pkgs,
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
      systemd.user.services.tmux = {
        enable = true;
        description = "tmux server";

        # creates the [Service] section
        # based on the emacs systemd service
        # does not source uses a login shell so does not load ~/.zshrc in case this is needed
        # just add -l(E.g bash -cl "...").
        serviceConfig = {
          Type = "forking";
          Restart = "always";
          ExecStart = "${pkgs.bash}/bin/bash -c 'source ${config.system.build.setEnvironment} ; exec ${pkgs.tmux}/bin/tmux start-server'";
          ExecStop = "${pkgs.tmux}/bin/tmux kill-server";
        };

        wantedBy = [ "default.target" ];
      };
      environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
        "/persist".users.${g.username}.directories = [
          ".local/share/atuin"
          ".local/share/aria2"
          ".local/share/tmux/resurrect"
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

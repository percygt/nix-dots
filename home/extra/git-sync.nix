{config, ...}: {
  services.git-sync = {
    enable = true;
    repositories = {
      nix-dots = {
        interval = 500;
        path = /home/percygt/nix-dots;
        uri = "git+ssh://percygt@github.com/percygt/nix-dots.git";
      };
    };
  };

  home.activation = {
    git-sync = config.lib.dag.entryAfter ["writeBoundary"] ''
      /usr/bin/systemctl start --user git-sync-nix-dots
    '';
  };
}

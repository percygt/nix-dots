{
  userModules = {
    git = {
      enable = true;
      gh.enable = true;
      glab.enable = true;
      credentials.enable = true;
    };
    gpg.enable = true;
    ssh.enable = true;
  };

  security = {
    sops.enable = true;
  };

  cli = {
    direnv.enable = true;
    fzf.enable = true;
    starship.enable = true;
    yazi.enable = true;
  };
}

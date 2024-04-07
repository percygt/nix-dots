{
  programs.borgmatic = {
    enable = true;
    backups = {
      data = {
        location = {
          sourceDirectories = ["/home/percygt/data"];
          repositories = ["/run/media/percygt/stash/backup/data"];
        };
      };
    };
  };
}

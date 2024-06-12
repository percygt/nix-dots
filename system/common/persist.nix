{
  fileSystems."/persist".neededForBoot = true;
  environment.persistence = {
    "/persist/system" = {
      hideMounts = true;
      directories = [
        "/var/lib/systemd/coredump"
        "/var/lib/nixos"
        "/srv"
        {
          directory = "/var/lib/colord";
          user = "colord";
          group = "colord";
          mode = "u=rwx,g=rx,o=";
        }
      ];
      files = [
        "/etc/machine-id"
      ];
    };
  };
}

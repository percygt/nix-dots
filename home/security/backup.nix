{pkgs, ...}: {
  home.packages = with pkgs; [
    pika-backup
    borgbackup
    borgmatic
  ];
}

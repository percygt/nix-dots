{pkgs, ...}: {
  programs = {
    gnome-disks.enable = true;
    file-roller.enable = true;
  };
  environment.systemPackages = with pkgs; [
    cinnamon.nemo-with-extensions
  ];
}

{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    cinnamon.nemo-with-extensions
  ];
}

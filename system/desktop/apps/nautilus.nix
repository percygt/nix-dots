{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      gnome.nautilus
      gnome.nautilus-python
      # ptyxis
      nautilus-open-any-terminal
    ];
    pathsToLink = [
      "/share/nautilus-python/extensions"
    ];
  };
}

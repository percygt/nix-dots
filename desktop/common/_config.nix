{
  pkgs,
  config,
  ...
}:
{
  modules.fileSystem.persist = {
    userData = {
      files = [ ".config/QtProject.conf" ];
    };
  };
  environment = {
    sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
    pathsToLink = [
      "/share/nautilus-python/extensions"
      "share/thumbnailers"
    ];
    systemPackages = with pkgs; [
      smartmontools
      nautilus-python
      gnome-disk-utility
      nautilus
      libheif
      libheif.out
    ];
  };
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    gnome.sushi.enable = true;
  };
  xdg = {
    mime = {
      defaultApplications = import ./__mimeApps.nix;
      addedAssociations = import ./__mimeApps.nix;
      removedAssociations = import ./__removedMime.nix;
    };
  };
  programs = {
    nautilus-open-any-terminal = {
      enable = true;
      terminal = config._base.terminal.defaultCmd;
    };
    seahorse.enable = true;
    gnome-disks.enable = true;
    file-roller.enable = true;
  };
}

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
    ];
    systemPackages = with pkgs; [
      smartmontools
      nautilus-python
      gnome-disk-utility
      nautilus
    ];
  };
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
  };
  xdg = {
    mime.defaultApplications = import ./.mimeApps.nix;
    mime.addedAssociations = import ./.mimeApps.nix;
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

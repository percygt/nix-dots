{
  pkgs,
  ...
}:
{
  # imports = [
  #   ./flatpak.nix
  # ];

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
  services.gvfs.enable = true;
  programs = {
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "footclient";
    };
    seahorse.enable = true;
    gnome-disks.enable = true;
    file-roller.enable = true;
  };
}

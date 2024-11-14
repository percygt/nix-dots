{
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./flatpak.nix
  ];

  modules.core.persist.userData.directories = [
    ".local/share/Mumble"
    ".local/share/lutris"
    ".config/Mumble"
    ".config/Logseq"
  ];

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "foot";
  };

  environment = {
    sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
    pathsToLink = [
      "/share/nautilus-python/extensions"
    ];

    systemPackages = with pkgs; [
      # nemo-with-extensions
      nautilus-python
      nautilus
    ];
  };
  programs = {
    seahorse.enable = true;
    gnome-disks.enable = true;
    file-roller.enable = true;
  };
}

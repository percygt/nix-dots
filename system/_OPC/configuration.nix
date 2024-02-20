{
  pkgs,
  username,
  hostName,
  stateVersion,
  lib,
  ...
}: {

  system.stateVersion = stateVersion;
  # user
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "input"
      "networkmanager"
      "video"
      "wheel"
      "audio"
    ];
  };
  # network
  networking = {
    inherit hostName;
  };
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce ["btrfs"];
  };
  hardware.opengl = {
    extraPackages = with pkgs; [
      mesa
    ];
  };

}

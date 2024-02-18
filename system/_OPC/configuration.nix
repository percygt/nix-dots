{
  pkgs,
  username,
  hostName,
  stateVersion,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./locale.nix
    ./audio.nix
  ];

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

  hardware.opengl = {
    extraPackages = with pkgs; [
      mesa
    ];
  };

}

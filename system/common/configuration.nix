{
  hostName,
  lib,
  stateVersion,
  username,
  ...
}: {
  nixpkgs.config = {
    allowUnfree = true;
    config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  networking = {
    inherit hostName;
    useDHCP = lib.mkDefault true;
  };

  system = {
    inherit stateVersion;
    # activationScripts.diff = {
    #   supportsDryActivation = true;
    #   text = ''
    #     ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
    #   '';
    # };
  };
  # Create dirs for home-manager
  systemd.tmpfiles.rules = [
    "d /nix/var/nix/profiles/per-user/${username} 0755 ${username} root"
  ];
}

{lib, ...}: {
  imports = [
    ./audioengine.nix
    ./autoupgrade.nix
    ./bootmanagement.nix
    ./ephemeral.nix
    ./graphics.nix
    ./net.nix
    ./ntp.nix
    ./packages.nix
    ./storage.nix
    ./systemd.nix
    ./zram.nix
    ./battery.nix
  ];

  core = {
    audioengine.enable = lib.mkDefault true;
    autoupgrade.enable = lib.mkDefault true;
    bootmanagement.enable = lib.mkDefault true;
    ephemeral.enable = lib.mkDefault true;
    graphics.enable = lib.mkDefault true;
    net.enable = lib.mkDefault true;
    ntp.enable = lib.mkDefault true;
    packages.enable = lib.mkDefault true;
    storage.enable = lib.mkDefault true;
    systemd.enable = lib.mkDefault true;
    zram.enable = lib.mkDefault true;
  };
}

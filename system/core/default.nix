{
  imports = [
    ./zram.nix
    ./bootmanagement.nix
    ./ntp.nix
    ./storage.nix
    ./audioengine.nix
    ./systemd.nix
    ./graphics.nix
    ./packages.nix
    ./autoupgrade.nix
    ./ephemeral.nix
  ];
}

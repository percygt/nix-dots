{desktop, ...}: {
  imports = [
    (./. + "/${desktop}.nix")
  ];
  # Enable location services
  location.provider = "geoclue2";
}

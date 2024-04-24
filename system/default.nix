{modulesPath, ...}: {
  imports = [
    # ./bin
    ./common
    ./core
    ./drivers
    ./desktop
    ./users
    ./infosec
    ./net
    ./virtualisation
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
}

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
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
}

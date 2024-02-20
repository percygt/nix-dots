{
  imports = [
    ./core
    ./network
    ./hardware
    ./programs
    ./services
    ./security
  ];
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
}

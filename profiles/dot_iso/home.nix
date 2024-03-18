{
  lib,
  config,
  outputs,
  ...
}: {
  imports = [
    ../../home/cli
    ../../home/shell
  ];
  home = {
    username = lib.mkDefault "nixos";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "23.11";
  };
  
  nixpkgs = {
    config.allowUnfree = true;
    overlays = builtins.attrValues outputs.overlays;
  };
}

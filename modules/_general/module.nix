{ lib, config, ... }:
{
  options._general = {
    username = lib.mkOption {
      description = "Username";
      type = lib.types.str;
      default = "percygt";
    };
    homeDirectory = lib.mkOption {
      description = "Home directory";
      default = "/home/${config._general.username}";
      type = lib.types.str;
    };
    stateVersion = lib.mkOption {
      description = "State version";
      default = "23.05";
      type = lib.types.str;
    };
    # dataDirectory = lib.mkOption {
    #   description = "Home directory";
    #   default = "${config._general.homeDirectory}/data";
    #   type = lib.types.str;
    # };
    # secretsDirectory = lib.mkOption {
    #   description = "Home directory";
    #   default = "${config._general.homeDirectory}/data/sikreto";
    #   type = lib.types.str;
    # };
    # syncthingDirectory = lib.mkOption {
    #   description = "Home directory";
    #   default = "${config._general.homeDirectory}/data/config/syncthing";
    #   type = lib.types.str;
    # };
    # flakeDirectory = lib.mkOption {
    #   description = "Flake directory";
    #   default = "${config._general.homeDirectory}/data/nix-dots";
    #   type = lib.types.str;
    # };

  };
}

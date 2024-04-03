{
  config,
  lib,
  inputs,
  ...
}: let
  sikreto = builtins.toString inputs.sikreto;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options = {
    security.sops = {
      enable =
        lib.mkEnableOption "Enable sops";
    };
  };

  config = lib.mkIf config.security.sops.enable {
    sops = {
      defaultSopsFile = "${sikreto}/secrets.enc.yaml";
      validateSopsFiles = false;
      gnupg = {
        home = "${config.xdg.dataHome}/gnupg";
        sshKeyPaths = [];
      };
    };
  };
}

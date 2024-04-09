{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  secretsPath = builtins.toString inputs.sikreto;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./git.nix
    ./ssh.nix
  ];

  options = {
    generic.sops = {
      enable =
        lib.mkEnableOption "Enable sops";
    };
  };

  config = lib.mkIf config.generic.sops.enable {
    home.packages = with pkgs; [
      sops
    ];
    sops = {
      defaultSopsFile = "${secretsPath}/secrets.enc.yaml";
      validateSopsFiles = false;
      gnupg = {
        home = "${config.xdg.dataHome}/gnupg";
        sshKeyPaths = [];
      };
    };
    home = {
      activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] ''
        /usr/bin/systemctl start --user sops-nix
      '';
    };
  };
}

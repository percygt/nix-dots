{
  lib,
  config,
  ...
}: {
  options.infosec = {
    ssh = {
      enable = lib.mkEnableOption "Enable ssh";
    };
  };
  config = lib.mkIf config.infosec.ssh.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    programs.ssh.startAgent = lib.mkForce false;

    networking.firewall.allowedTCPPorts = [22];
  };
}

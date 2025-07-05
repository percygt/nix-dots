{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.modules.persist;
in
{
  config = lib.mkIf (cfg.enable && config.modules.ephemeral.enable) {
    fileSystems.${cfg.prefix}.neededForBoot = true;
    environment.etc."machine-id".source = "${cfg.systemPrefix}/etc/machine-id";
    environment.persistence = {
      # System persistence
      ${cfg.systemPrefix} = {
        hideMounts = true;
        inherit (cfg.systemData) files;
        directories = [
          "/var/lib/systemd/coredump"
          "/var/lib/nixos"
          "/srv"
          {
            directory = "/var/lib/colord";
            user = "colord";
            group = "colord";
            mode = "u=rwx,g=rx,o=";
          }
          # files = [ "/etc/machine-id" ];
        ] ++ cfg.systemData.directories;
      };
      # My user persistence
      ${cfg.prefix}.users.${username} = {
        inherit (cfg.userData) files;
        directories = [
          ".local/share/nix"
          ".local/state/nix"
          ".local/state/home-manager"
        ] ++ cfg.userData.directories;
      };
    };
  };
}

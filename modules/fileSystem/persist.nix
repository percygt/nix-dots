{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.modules.fileSystem.persist;
  inherit (lib)
    mkAliasOptionModule
    mkIf
    ;
in
{
  # Actually create the aliases options.
  imports = [
    (mkAliasOptionModule [ "persistSystem" ] [ "modules" "fileSystem" "persist" "systemData" ])
    (mkAliasOptionModule [ "persistHome" ] [ "modules" "fileSystem" "persist" "userData" ])
  ];
  config = mkIf (cfg.enable && config.modules.fileSystem.ephemeral.enable) {
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
        ]
        ++ cfg.systemData.directories;
      };
      # My user persistence
      ${cfg.prefix}.users.${username} = {
        inherit (cfg.userData) files;
        directories = [
          ".local/share/nix"
          ".local/state/nix"
          ".local/state/home-manager"
        ]
        ++ cfg.userData.directories;
      };
    };
  };
}

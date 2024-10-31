{
  pkgs,
  lib,
  config,
  ...
}:
let
  g = config._general;
in
{
  environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
    "/persist" = {
      users.${g.username} = {
        directories = [
          ".local/share/Mumble"
          ".local/share/lutris"
          ".config/Mumble"
          ".config/Logseq"
        ];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    nemo-with-extensions
  ];
  programs = {
    seahorse.enable = true;
    gnome-disks.enable = true;
    file-roller.enable = true;
  };
}

{
  lib,
  config,
  username,
  ...
}: {
  options = {
    dev.enable =
      lib.mkEnableOption "Enable devtools";
  };

  config = lib.mkIf config.dev.enable {
    home-manager.users.${username} = {
      imports = [
        ./git
        ./go.nix
        ./common.nix
        ./jujutsu.nix
      ];
    };
  };
}

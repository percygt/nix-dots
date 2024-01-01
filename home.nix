{
  username,
  pkgs,
  ...
}: let
  homeDirectory = "/home/${username}";
  commonConfig = builtins.fromTOML (builtins.readFile ./common/config.toml);
in {
  imports = [
    ./home
    ./nixtools.nix
    ./cli.nix
  ];
  news.display = "silent";

  targets.genericLinux.enable = true;

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };
  home = {
    inherit username homeDirectory;
    shellAliases = commonConfig.aliases;
    sessionVariables = commonConfig.variables;
  };
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}

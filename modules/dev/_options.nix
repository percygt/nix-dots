{
  lib,
  pkgs,
  ...
}:
{
  options.modules.dev = {
    ghq.enable = lib.mkEnableOption "Enable ghq";
    glab.enable = lib.mkEnableOption "Enable glab";
    gh.enable = lib.mkEnableOption "Enable gh";
    git.package = lib.mkOption {
      description = "Git package";
      type = lib.types.package;
      default = pkgs.git;
    };
    process-compose.enable = lib.mkEnableOption "Enable process-compose";
    jujutsu.enable = lib.mkEnableOption "Enable jujutsu";
    tools = {
      enable = lib.mkEnableOption "Enable devtools";
      codingPackages = lib.mkOption {
        description = "Extrapackages for editor";
        type = lib.types.listOf lib.types.package;
        default = import ./__codingPackages.nix pkgs;
      };
    };
  };
}

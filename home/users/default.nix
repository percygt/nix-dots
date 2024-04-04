{
  lib,
  username,
  ...
}: {
  imports = lib.optionals (builtins.pathExists ./${username}) [
    ./${username}
  ];

  options = {
    userModules = {
      git = {
        enable =
          lib.mkEnableOption "Enable git";
        credentials.enable = lib.mkEnableOption "Enable git credentials";
        glab.enable = lib.mkEnableOption "Enable git credentials";
        ghq.enable = lib.mkEnableOption "Enable ghq";
        gh.enable = lib.mkEnableOption "Enable gh";
      };
      ssh.enable = lib.mkEnableOption "Enable ssh";
      gpg.enable = lib.mkEnableOption "Enable gpg";
    };
  };
}

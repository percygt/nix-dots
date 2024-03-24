{
  pkgs,
  config,
  ...
}: let
  PASSWORD_STORE_DIR =
    if (builtins.pathExists "/data/pass")
    then "/data/pass"
    else "${config.xdg.dataHome}/password-store";
in {
  programs = {
    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [
        exts.pass-otp
        exts.pass-import
      ]);
      settings = {
        inherit PASSWORD_STORE_DIR;
      };
    };
  };
  home.packages = with pkgs; [
    zbar
    wl-clipboard
  ];
}

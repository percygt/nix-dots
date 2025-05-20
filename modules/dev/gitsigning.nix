{
  config,
  lib,
  ...
}:
let
  g = config._base;
in
{
  config = lib.mkIf config.modules.dev.gitsigning.enable {
    programs.git = {
      userName = "Percy Timon";
      userEmail = "percygt.dev@gmail.com";
      signing = {
        signByDefault = true;
        format = "openpgp";
        key = g.security.gpg.signingKey;
        signer = lib.getExe g.security.gpg.package;
      };
    };
  };
}

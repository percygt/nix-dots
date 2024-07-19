{
  inputs,
  configx,
  username,
  ...
}:
let
  scheme = configx.colors.scheme.syft;
in
# scheme = "${inputs.tt-schemes}/base24/one-dark.yaml";
{
  imports = [ inputs.base16.nixosModule ];
  inherit scheme;
  home-manager.users.${username} = {
    imports = [ inputs.base16.homeManagerModule ];
    inherit scheme;
  };
}

{
  inputs,
  configx,
  username,
  ...
}:
{
  imports = [ inputs.base16.nixosModule ];
  scheme = configx.colors.scheme.syft;
  home-manager.users.${username} = {
    imports = [ inputs.base16.homeManagerModule ];
    scheme = configx.colors.scheme.syft;
  };
}

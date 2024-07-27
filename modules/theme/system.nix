{
  inputs,
  username,
  config,
  ...
}:
{
  imports = [
    ./module.nix
    inputs.base16.nixosModule
  ];
  config = {
    home-manager.users.${username} = import ./home.nix;
    scheme = config.modules.theme.colorscheme;
  };
}

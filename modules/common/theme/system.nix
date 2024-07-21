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
  home-manager.users.${username} = import ./home.nix;
  scheme = config.setTheme.colorscheme;
}

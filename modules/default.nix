{
  self,
  inputs,
  desktop,
  lib,
  profile,
  outputs,
  username,
  libx,
  ...
}: let
  commonImports = [
    ./common
    ./core
    ./drivers
    ./desktop
    ./users
    ./infosec
    ./net
    ./extras
    ./virtualisation
  ];
  # commonHomeImports = [
  #   ./cli/home.nix
  #   ./desktop/home.nix
  #   ./editor/home.nix
  #   ./terminal/home.nix
  #   ./shell/home.nix
  #   ./infosec/home.nix
  #   ./dev/home.nix
  #   ./common/home.nix
  # ];
  homePathList =
    builtins.filter (path: builtins.pathExists path) (map (dir: ./${dir}/home.nix)
      (builtins.attrNames (removeAttrs (builtins.readDir ./.) ["default.nix" "home.nix"])));
in {
  imports =
    commonImports
    ++ [
      # profile specific configuration.nix
      "${self}/profiles/${profile}/configuration.nix"
    ];

  home-manager.users.${username} = {
    config,
    isGeneric,
    ...
  }: {
    imports =
      commonHomeImports
      ++ [
        # profile specific home.nix
        "${self}/profiles/${profile}/home.nix"
        inputs.sops-nix.homeManagerModules.sops
      ]
      ++ homePathList
      ++ lib.optionals isGeneric [
        ./generic
      ];
  };
}

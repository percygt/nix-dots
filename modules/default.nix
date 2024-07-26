{
  self,
  profile,
  username,
  ...
}:
{
  imports =
    builtins.filter (path: builtins.pathExists path) (
      map (dir: ./${dir}) (builtins.attrNames (removeAttrs (builtins.readDir ./.) [ "default.nix" ]))
    )
    ++ [ "${self}/profiles/${profile}" ]
    ++ [ "${self}/config" ];

  home-manager.users.${username} = import "${self}/config";
}

{
  ll = "ls -l";
  la = "ls -la";
  lzg = "lazygit";
  lzd = "lazydocker";
  ls = "eza --sort type --icons -F -H --group-directories-first -1";
  neofetch = "fastfetch";
  cat = "bat -p";
  rm = "rm -i";
  mv = "mv -n";
  r = "rsync --archive --verbose --human-readable --progress --one-file-system --ignore-existing";
  sc = "systemctl";
  scu = "systemctl --user";
  jc = "journalctl -ex --unit";
  jcu = "journalctl --user -ex --unit";
  hms = "home-manager switch --flake $FLAKE_PATH";
  code = "codium";
  v = "nvim";
  y = "yazi";
  dc = "docker compose";
  n2ne = "nvim $FLAKE_PATH/nixpkgs/node/packages.json";
  n2ni = "node2nix -i $FLAKE_PATH/nixpkgs/node/packages.json -e $FLAKE_PATH/nixpkgs/node/node-env.nix -o $FLAKE_PATH/nixpkgs/node/packages.nix -c $FLAKE_PATH/nixpkgs/node/default.nix";
}

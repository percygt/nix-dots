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
  code = "codium";
  v = "nvim";
  y = "yazi";
  dc = "docker compose";
  n2ne = "nvim $FLAKE_PATH/nixpkgs/node/packages.json";
  n2ni = "node2nix -i $FLAKE_PATH/nixpkgs/node/packages.json -e $FLAKE_PATH/nixpkgs/node/node-env.nix -o $FLAKE_PATH/nixpkgs/node/packages.nix -c $FLAKE_PATH/nixpkgs/node/default.nix";
  isobld = "nix build .'?submodules=1#'nixosConfigurations.iso.config.system.build.isoImage --impure";
  suisobld = "sudo nix build .'?submodules=1#'nixosConfigurations.iso.config.system.build.isoImage";
  mkVM = "qemu-system-x86_64 -enable-kvm -m 2G -boot menu=on -drive file=vm.img -cpu=host -vga virtio -display sdl,gl=on -cdrom";
  stow_home = "stow -d /data/ -t $HOME stow_home/";
}

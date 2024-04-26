{flakeDirectory, ...}: {
  home.shellAliases = {
    ll = "eza --group --header --group-directories-first --long --git --all --binary --icons";
    la = "ll -a";
    ls = "eza --group-directories-first --all -1";
    shredf = "shred -uvn 10";
    tree = "eza --tree";
    cat = "bat -p";
    dig = "dog";
    mv = "mv -n";
    rm = "rm -i";
    rmrf = "rm -rf";
    rmt = "trash";
    r = "rsync --archive --verbose --human-readable --progress --one-file-system --ignore-existing";
    sc = "systemctl";
    scu = "systemctl --user";
    jc = "journalctl -ex --unit";
    jcu = "journalctl --user -ex --unit";
    curl = "curlie";
    dc = "docker compose";
    nd = "nix develop";
    buildIsoMinimal = "nix build .#nixosConfigurations.iso-minimal.config.system.build.isoImage";
    buildIsoGraphical = "nix build .#nixosConfigurations.iso-graphical.config.system.build.isoImage";
    n2ne = "nvim $FLAKE_PATH/packages/node/packages.json";
    n2ni = "node2nix -i $FLAKE_PATH/packages/node/packages.json -e $FLAKE_PATH/packages/node/node-env.nix -o $FLAKE_PATH/packages/node/packages.nix -c $FLAKE_PATH/packages/node/default.nix";
    nfu = "nix flake update";
    tldrf = "tldr --list | fzf --preview=\"tldr {1} --color=always\" --preview-window=right,70% | xargs tldr";
    nfui = "nix flake lock --update-input";
    hms = "home-manager switch --flake ${flakeDirectory}#$hostname";
    ns = "sudo nixos-rebuild switch --flake ${flakeDirectory}#$hostname";
  };
}

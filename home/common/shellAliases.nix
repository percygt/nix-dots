{
  home.shellAliases = {
    ll = "eza --group --header --group-directories-first --long --git --all --binary --icons";
    la = "ll -a";
    ls = "eza --group-directories-first --all -1";
    tree = "eza --tree";
    cat = "bat -p";
    dig = "dog";
    grep = "rg";
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
    niso = "nix build .#nixosConfigurations.dot-iso.config.system.build.isoImage --impure";
    n2ne = "nvim $FLAKE_PATH/packages/node/packages.json";
    n2ni = "node2nix -i $FLAKE_PATH/packages/node/packages.json -e $FLAKE_PATH/packages/node/node-env.nix -o $FLAKE_PATH/packages/node/packages.nix -c $FLAKE_PATH/packages/node/default.nix";
    nfu = "nix flake update";
    tldr = "tldr --list | fzf --preview=\"tldr {1} --color=always\" --preview-window=right,70% | xargs tldr";
    nfui = "nix flake lock --update-input";
  };
}

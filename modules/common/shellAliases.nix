{ flakeDirectory, ... }:
{
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
    date-sortable = "date +%Y-%m-%dT%H:%M:%S%Z"; # ISO 8601 date format with local timezone
    date-sortable-utc = "date -u +%Y-%m-%dT%H:%M:%S%Z"; # ISO 8601 date format with UTC timezone
    d = "dua --stay-on-filesystem interactive";
    r = "rsync --archive --verbose --human-readable --progress --one-file-system --ignore-existing";
    sc = "systemctl";
    scu = "systemctl --user";
    jc = "journalctl -exf --unit";
    jcu = "journalctl --user -exf --unit";
    curl = "curlie";
    dc = "docker compose";
    # nd = "nix develop";
    buildIsoMinimal = "nix build .#nixosConfigurations.iso-minimal.config.system.build.isoImage";
    buildIsoGraphical = "nix build .#nixosConfigurations.iso-graphical.config.system.build.isoImage";
    n2ne = "nvim $FLAKE_PATH/packages/node/packages.json";
    n2ni = "node2nix -i $FLAKE_PATH/packages/node/packages.json -e $FLAKE_PATH/packages/node/node-env.nix -o $FLAKE_PATH/packages/node/packages.nix -c $FLAKE_PATH/packages/node/default.nix";
    tldrf = "tldr --list | fzf --preview=\"tldr {1} --color=always\" --preview-window=right,70% | xargs tldr";
    ts = "tailscale";
    tssh = "tailscale ssh";
    tst = "tailscale status";
    tsu = "sudo tailscale up --ssh --operator=$USER";
    tsd = "tailscale down";
    cleanup-nix = "nh clean all --keep-since 10d --keep 3";
    nfu = "nix flake update --accept-flake-config";
    nsu = "nh os switch -u -- --accept-flake-config";
    ns = "nh os switch -- --accept-flake-config";
    ns_ = "systemctl start --user nixos-rebuild.service";
    hs = "nh home switch ${flakeDirectory}";
    nhs = "ns;hms";
    swaytree = "swaymsg -t get_tree | nvim -R";
    swayinputs = "swaymsg -t get_inputs | nvim -R";
    swayoutputs = "swaymsg -t get_outputs | nvim -R";
    nix-repl-flake = "nix repl --expr \"(builtins.getFlake (toString ${flakeDirectory})).nixosConfigurations.$hostname\"";
  };
}

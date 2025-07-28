{ config, ... }:
let
  inherit (config._base) flakeDirectory;
in
{
  home.shellAliases = {
    dig = "dog";
    cat = "bat";
    mv = "mv -n";
    rm = "rm -i";
    rmrf = "rm -rf";
    rmt = "trash";
    d = "dua --stay-on-filesystem interactive";
    r = "rsync --archive --verbose --human-readable --progress --one-file-system --ignore-existing";
    sc = "systemctl";
    scu = "systemctl --user";
    jc = "journalctl -exf --unit";
    jcu = "journalctl --user -exf --unit";
    curl = "curlie";
    dc = "docker compose";
    ts = "tailscale";
    tssh = "tailscale ssh";
    tst = "tailscale status";
    tsu = "sudo tailscale up --ssh --operator=$USER";
    tsd = "tailscale down";
    noms = "nom shell";
    nomd = "nom develop";
    nix-repl-flake = "nix repl --expr \"(builtins.getFlake (toString ${flakeDirectory})).nixosConfigurations.$hostname\"";
    lsblk = "lsblk -o NAME,SIZE,TYPE,FSTYPE,FSVER,MOUNTPOINTS";
    cleanup-results = "bash -c \"find . -type l -name 'result*' -exec echo 'unlinking {}' ; -exec unlink {}\"";
    gcstore = "bash -c \"nix-env --delete-generations +3 ; nix store gc --verbose ; nix store optimise --verbose\"";
  };
}

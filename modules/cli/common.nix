{pkgs, ...}: {
  home.packages = with pkgs; [
    tailscale
    ripgrep
    jdupes
    hyperfine
    most
    procs
    exiftool
    sd
    entr
    glances
    cointop
    ddgr
    buku
    mutt
    newsboat
    navi
    bandwhich
    scc
    git
    du-dust
    dua
    duf
    yq-go # portable command-line YAML, JSON and XML processor
    fd
    curlie
    p7zip
    jq
    aria2
    gping
    xcp
    dogdns
    dive
  ];
}

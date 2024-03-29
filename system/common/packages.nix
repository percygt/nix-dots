{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bat
    curl
    dig
    dua
    duf
    aria2
    du-dust
    eza
    fd
    file
    git
    jq
    killall
    nfs-utils
    ntfs3g
    pciutils
    ripgrep
    rsync
    tpm2-tss
    traceroute
    tree
    unzip
    unrar
    p7zip
    usbutils
    vim
    wget
    yq-go
  ];
}

{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    core.packages = {
      enable =
        lib.mkEnableOption "Enable core packages";
    };
  };

  config = lib.mkIf config.core.packages.enable {
    environment.systemPackages = with pkgs; [
      (neovim-nightly.overrideAttrs
        (_: {CFLAGS = "-O3";}))
      foot
      bat
      curl
      aria2
      wget

      lshw
      wev
      lsof
      dig
      dua
      duf
      du-dust
      eza
      fd
      file
      git
      jq
      fzf
      killall
      nfs-utils
      ntfs3g
      pciutils
      ripgrep
      rsync
      tpm2-tss
      traceroute
      tree
      cryptsetup

      unzip
      unrar
      p7zip

      usbutils
      yq-go
      #nix
      comma
    ];
  };
}

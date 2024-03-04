{pkgs}: {
  initial = pkgs.callPackage ./1_initial.nix {};
  btrfs = pkgs.callPackage ./2_btrfs.nix {};
  snapper = pkgs.callPackage ./3_snapper.nix {};
  grubbtrfs = pkgs.callPackage ./4_grubbtrfs.nix {};
  firmwareandcodecs = pkgs.callPackage ./5_firmwareandcodecs.nix {};
  grubtheme = pkgs.callPackage ./6_grubtheme.nix {};
  homesetup = pkgs.callPackage ./7_homesetup.nix {};
  appinstall = pkgs.callPackage ./8_appinstall.nix {};
  kvminstall = pkgs.callPackage ./9_kvminstall.nix {};
}

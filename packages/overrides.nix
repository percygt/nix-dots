{pkgs}: {
  ripgrep = pkgs.ripgrep.override {withPCRE2 = true;};
}

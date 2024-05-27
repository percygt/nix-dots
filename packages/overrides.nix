{
  prev,
  final,
}: {
  ripgrep = prev.ripgrep.override {withPCRE2 = true;};
  borgmatic = prev.borgmatic.override {enableSystemd = false;};
}

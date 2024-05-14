{
  prev,
  final,
}: {
  ripgrep = prev.ripgrep.override {withPCRE2 = true;};
}

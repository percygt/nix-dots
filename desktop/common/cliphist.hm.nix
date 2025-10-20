{
  pkgs,
  ...
}:
{
  services.cliphist.enable = true;
  home.packages = with pkgs; [
    cliphist
    chafa
    libsixel
  ];
}

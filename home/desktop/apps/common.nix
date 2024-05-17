{pkgs, ...}: {
  home.packages = with pkgs; [
    chromium
    qalculate-gtk
    audacity
    amberol
    foliate
    mumble
    obsidian
  ];
}

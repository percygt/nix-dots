{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    foot
  ];
}

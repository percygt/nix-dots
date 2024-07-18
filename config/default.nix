{ username, inputs }:
rec {
  background = {
    opacity = 0.8;
    wallpaper = {
      url = "https://images.unsplash.com/photo-1520264914976-a1ddb24d2114?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=michael-aleo-FDhds8oz8bA-unsplash.jpg";
      sha256 = "1dwy2619vmgca430m0vsq50289bwqi5nc5m0c02bri5phdmfxj6i";
    };
  };
  colors =
    (import ./colors.nix)
    // inputs.nix-colors.lib
    // {
      scheme = {
        syft = import ./schemes/syft.nix;
      };
    };
  fonts = import ./fonts.nix;
  themes = import ./themes.nix;
  homeDirectory = "/home/${username}";
  flakeDirectory = "${homeDirectory}/data/nix-dots";
  corePackages = pkgs: import ./corePackages.nix { inherit pkgs; };
}

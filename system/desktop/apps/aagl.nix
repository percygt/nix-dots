{inputs, ...}: {
  imports = [inputs.aagl.nixosModules.default];
  nix.settings = inputs.aagl.nixConfig;
  programs = {
    anime-game-launcher.enable = true;
    anime-games-launcher.enable = true;
    anime-borb-launcher.enable = true;
    honkers-railway-launcher.enable = true;
    honkers-launcher.enable = true;
  };
}

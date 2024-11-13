{
  inputs,
  config,
  # username,
  ...
}:
let
  g = config._base;
in
{
  imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

  desktop.modules.xdg.enable = true;

  editor.neovim.enable = true;

  modules.cli = {
    atuin.enable = true;
    direnv.enable = true;
    extra.enable = true;
    starship.enable = true;
    tui.enable = true;
    yazi.enable = true;
  };

  home = {
    shellAliases = {
      hms = "home-manager switch --flake ${g.flakeDirectory}#$hostname";
      hmr = "home-manager generations | fzf --tac | awk '{print $7}' | xargs -I{} bash {}/activate";
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
}

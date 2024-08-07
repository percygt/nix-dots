{ inputs, config, ... }:
let
  g = config._general;
in
{
  imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

  home.persistence."/persist/home/${g.username}" = {
    directories = [
      ".local/share/nix"
      ".local/share/atuin"
      ".local/share/nvim"
      ".local/share/fish"
      ".local/share/zoxide"
      ".config/BraveSoftware/Brave-Browser"
    ];
    files = [ ".local/share/tmux/resurrect/last" ];
    allowOther = true;
  };

  # browser.brave.enable = true;

  desktop.modules.xdg.enable = true;

  editor.neovim.enable = true;

  terminal = {
    foot.enable = true;
    wezterm.enable = true;
  };

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

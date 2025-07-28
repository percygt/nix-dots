{
  pkgs,
  ...
}:

{
  imports = [
    ../modules/_base/+module.nix
    ../modules/themes/+extras
    ../modules/themes/+home.nix
    ../modules/dev/+module.nix
    ../modules/editor/neovim/+module.nix
    ../modules/editor/neovim/+home.nix
  ];
  nixpkgs.config.allowUnfree = true;

  modules.editor.neovim.enable = true;
  dconf.enable = true;
  gtk = {
    enable = true;
    iconTheme = {
      name = "elementary-Xfce-dark";
      package = pkgs.elementary-xfce-icon-theme;
    };
    theme = {
      name = "zukitre-dark";
      package = pkgs.zuki-themes;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  programs.gpg.enable = true;

  services.gpg-agent.enable = true;
}

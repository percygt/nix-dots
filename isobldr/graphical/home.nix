{
  self,
  username,
  stateVersion,
  homeDirectory,
  ...
}: {
  imports = [
    "${self}/modules/cli/starship.nix"
    "${self}/modules/editor/neovim/home.nix"
  ];

  programs.home-manager.enable = true;

  editor.neovim.home.enable = true;

  cli.starship.home.enable = true;

  home = {
    inherit
      username
      stateVersion
      homeDirectory
      ;
    shellAliases = {
      ni = "sudo nixos-install --no-root-passwd --flake";
    };
  };

  home.file.".config/autostart/foot.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Exec=foot -m fish -c 'mknixos' 2>&1
    Hidden=false
    NoDisplay=false
    X-GNOME-Autostart-enabled=true
    Name[en_NG]=Terminal
    Name=Terminal
    Comment[en_NG]=Start Terminal On Startup
    Comment=Start Terminal On Startup
  '';
}

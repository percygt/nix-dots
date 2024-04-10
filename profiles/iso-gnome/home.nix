{
  flakeDirectory,
  self,
  lib,
  config,
  ...
}: {
  home = {
    shellAliases = {
      ns = "sudo nixos-rebuild switch --flake ${flakeDirectory}#$hostname";
      ni = "sudo nixos-install --no-root-passwd --flake";
    };
  };

  home = {
    activation = {
      copySelfToHome =
        lib.hm.dag.entryAfter ["linkGeneration"]
        ''
          mkdir -p "${config.home.homeDirectory}/nix-dots"
          cp -r "${self}/." "${config.home.homeDirectory}/nix-dots"
          sudo chmod -R 1000:users "${config.home.homeDirectory}/nix-dots"
        '';
    };
  };

  home.file.".config/autostart/foot.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Exec=foot -m fish -c 'tmux' 2>&1
    Hidden=false
    NoDisplay=false
    X-GNOME-Autostart-enabled=true
    Name[en_NG]=Terminal
    Name=Terminal
    Comment[en_NG]=Start Terminal On Startup
    Comment=Start Terminal On Startup
  '';
  # home.file.nix-dots = {
  #   source = self;
  # };

  editor.neovim.enable = true;

  cli = {
    direnv.enable = true;
    starship.enable = true;
    yazi.enable = true;
  };
}

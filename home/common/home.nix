{
  lib,
  username,
  stateVersion,
  homeDirectory,
  config,
  pkgs,
  self,
  inputs,
  ...
}: {
  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home.file = {
    "${config.xdg.cacheHome}/nix-index/files".source =
      inputs.nix-index-database.legacyPackages.${pkgs.system}.database;
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  home = {
    inherit
      username
      stateVersion
      homeDirectory
      ;
    activation.report-changes = config.lib.dag.entryAnywhere ''
      if [[ -n "$oldGenPath" && -n "$newGenPath" ]]; then
        ${pkgs.nvd}/bin/nvd diff $oldGenPath $newGenPath
      fi
    '';
  };

  xdg.dataFile.backgrounds.source = "${self}/lib/backgrounds";
  xdg.configFile."nixpkgs/config.nix".text = ''
    {
      allowUnfree = true;
    }
  '';

  nixpkgs.config = {
    # Disable if you don't want unfree packages
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = _: true;
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  news = {
    display = "silent";
    json = lib.mkForce {};
    entries = lib.mkForce [];
  };
}

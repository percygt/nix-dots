{
  lib,
  username,
  stateVersion,
  homeDirectory,
  self,
  isGeneric,
  pkgs,
  ...
}: {
  imports = [
    ./shellAliases.nix
    ./sessionVariables.nix
  ];

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

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
    activation = lib.optionalAttrs (!isGeneric) {
      rmUselessDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
        rm -rf ${homeDirectory}/.nix-defexpr
        rm -rf ${homeDirectory}/.nix-profile
      '';
    };
  };

  xdg.dataFile.backgrounds.source = "${self}/lib/backgrounds";
  xdg.configFile."nixpkgs/config.nix".text = ''
    {
      allowUnfree = true;
    }
  '';

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

  nix = {
    package = lib.mkDefault pkgs.nixVersions.git;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      warn-dirty = false;
      max-jobs = "auto";
      trusted-users = ["@wheel" "root"];
      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://percygtdev.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "percygtdev.cachix.org-1:AGd4bI4nW7DkJgniWF4tS64EX2uSYIGqjZih2UVoxko="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}

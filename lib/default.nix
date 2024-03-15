{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
  listImports = path: modules:
    lib.forEach modules (
      mod:
        path + "/${mod}"
    );
  defaultUsername = "percygt";
  mkDefault = {
    username,
    pkgs,
    profile,
    is_iso,
  }: rec {
    homeDirectory = "/home/${username}";
    flakeDirectory = "${homeDirectory}/nix-dots";
    stateVersion = "23.11";
    colors = (import ./colors.nix).syft;
    targer_user = "percygt"; # for iso
    home-manager = {
      programs.home-manager.enable = true;
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
      home = {
        inherit
          username
          stateVersion
          homeDirectory
          ;
        shellAliases = import ./aliases.nix;
        sessionVariables =
          (import ./variables.nix)
          // {FLAKE_PATH = flakeDirectory;};
      };
    };

    configuration = {
      users.users.${username} = {
        shell = "${pkgs.fish}/bin/fish";
        home = homeDirectory;
        isNormalUser = true;
        extraGroups = [
          "input"
          "networkmanager"
          "video"
          "wheel"
          "audio"
          "git"
        ];
      };
      time.timeZone = "Asia/Manila";
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_PH.UTF-8";
        LC_IDENTIFICATION = "en_PH.UTF-8";
        LC_MEASUREMENT = "en_PH.UTF-8";
        LC_MONETARY = "en_PH.UTF-8";
        LC_NAME = "en_PH.UTF-8";
        LC_NUMERIC = "en_PH.UTF-8";
        LC_PAPER = "en_PH.UTF-8";
        LC_TELEPHONE = "en_PH.UTF-8";
        LC_TIME = "en_PH.UTF-8";
      };
      console.keyMap = "us";
      services.xserver = {
        xkb.layout = "us";
        xkb.variant = "";
      };
      networking = {
        hostName = profile;
      };
      nixpkgs = {
        config = {
          allowUnfree = true;
        };
      };
      system.stateVersion = stateVersion;
    };

    args =
      {
        inherit
          inputs
          username
          profile
          pkgs
          colors
          listImports
          flakeDirectory
          homeDirectory
          ;
      }
      // lib.optionalAttrs is_iso {inherit targer_user;};
  };
in {
  mkNixOS = {
    profile,
    pkgs,
    system,
    username ? defaultUsername,
    nixosModules ? [],
    homeManagerModules ? [],
    is_laptop ? false,
    is_iso ? false,
  }: let
    default = mkDefault {inherit is_iso username pkgs profile;};
  in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = default.args // {inherit is_laptop;};
      modules =
        nixosModules
        ++ [
          default.configuration
          ../profiles/${profile}/configuration.nix
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username} = {
                imports =
                  homeManagerModules
                  ++ [
                    default.home-manager
                    ../profiles/${profile}/home.nix
                  ];
              };
              extraSpecialArgs = default.args // {inherit is_laptop;};
            };
          }
        ];
    };

  mkHomeManager = {
    profile,
    pkgs,
    username ? defaultUsername,
    homeManagerModules ? [],
    standalone_home ? false,
    is_laptop ? false,
    is_iso ? false,
  }: let
    default = mkDefault {inherit username pkgs profile is_iso;};
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules =
        homeManagerModules
        ++ [
          default.home-manager
          ../profiles/${profile}/home.nix
        ];
      extraSpecialArgs = default.args // {inherit standalone_home is_laptop;};
    };
}

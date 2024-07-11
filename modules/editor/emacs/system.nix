{
  pkgs,
  inputs,
  lib,
  config,
  username,
  ...
}: let
  cfg = config.editor.emacs;

  emacsConfig = pkgs.concatTextFile {
    name = "config.el";
    files = map (dir: ./config/${dir}) (builtins.attrNames (builtins.readDir ./config));
  };

  extraPackages = import ./extraPackages.nix {inherit pkgs;};

  emacs = pkgs.emacsWithPackagesFromUsePackage {
    inherit (cfg) package;
    alwaysEnsure = true;
    config = builtins.readFile emacsConfig;
    extraEmacsPackages = epkgs:
      [epkgs.treesit-grammars.with-all-grammars]
      ++ extraPackages;
  };

  emacsWithExtraPackages = pkgs.runCommand "emacs" {nativeBuildInputs = [pkgs.makeWrapper];} ''
    makeWrapper ${emacs}/bin/emacsclient $out/bin/emacsclient --prefix PATH : ${lib.makeBinPath extraPackages}
    makeWrapper ${emacs}/bin/emacs $out/bin/emacs --prefix PATH : ${lib.makeBinPath extraPackages}
  '';
  # emacsClientWithExtraPackages = pkgs.runCommand "emacs" {nativeBuildInputs = [pkgs.makeWrapper];} ''
  #   makeWrapper ${emacs}/bin/emacsclient $out/bin/emacsclient --prefix PATH : ${lib.makeBinPath extraPackages}
  #   makeWrapper ${emacs}/bin/emacs $out/bin/emacs --prefix PATH : ${lib.makeBinPath extraPackages}
  # '';
in {
  options.editor = {
    emacs.system.enable = lib.mkEnableOption "Enable emacs systemwide";
    emacs.package = lib.mkOption {
      description = "emacs package to use";
      default = pkgs.emacs-unstable-pgtk.override {withTreeSitter = true;};
      type = lib.types.package;
    };
  };
  config = lib.mkIf config.editor.emacs.system.enable {
    nixpkgs.overlays = [inputs.emacs-overlay.overlays.default];
    environment.systemPackages = [
      (pkgs.aspellWithDicts (dicts: with dicts; [en en-computers]))
      emacsWithExtraPackages
    ];
    services.emacs = {
      enable = true;
      package = emacsWithExtraPackages;
      startWithGraphical = true;
    };
    environment.persistence = lib.mkIf config.core.ephemeral.enable {
      "/persist" = {
        users.${username} = {
          directories = [
            ".local/share/emacs"
            ".local/cache/emacs"
          ];
        };
      };
    };
    home-manager.users.${username} = {
      imports = [./home.nix];
      editor.emacs.home.enable = lib.mkDefault true;
    };
  };
}

{
  pkgs,
  inputs,
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.modules.editor.emacs;

  emacsConfig = pkgs.concatTextFile {
    name = "config.el";
    files = map (dir: ./config/${dir}) (builtins.attrNames (builtins.readDir ./config));
  };

  extraPackages = import ./extraPackages.nix { inherit pkgs; };

  emacs = pkgs.emacsWithPackagesFromUsePackage {
    inherit (cfg) package;
    alwaysEnsure = true;
    config = builtins.readFile emacsConfig;
    extraEmacsPackages = epkgs: [ epkgs.treesit-grammars.with-all-grammars ] ++ extraPackages;
  };

  emacsWithExtraPackages = pkgs.runCommand "emacs" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
    makeWrapper ${emacs}/bin/emacsclient $out/bin/emacsclient --prefix PATH : ${lib.makeBinPath extraPackages}
    makeWrapper ${emacs}/bin/emacs $out/bin/emacs --prefix PATH : ${lib.makeBinPath extraPackages}
  '';
in
{
  options.modules.editor = {
    emacs.enable = lib.mkEnableOption "Enable emacs systemwide";
    emacs.package = lib.mkOption {
      description = "emacs package to use";
      default = pkgs.emacs-unstable-pgtk.override { withTreeSitter = true; };
      type = lib.types.package;
    };
  };
  config = lib.mkIf config.modules.editor.emacs.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];
    environment.systemPackages = [
      (pkgs.aspellWithDicts (
        dicts: with dicts; [
          en
          en-computers
        ]
      ))
      emacsWithExtraPackages
    ];
    # services.emacs = {
    #   enable = true;
    #   package = emacsWithExtraPackages;
    #   startWithGraphical = true;
    # };
    environment.persistence = lib.mkIf config.modules.core.ephemeral.enable {
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
      imports = [ ./home.nix ];
      services.emacs = {
        enable = true;
        package = emacsWithExtraPackages;
        client.enable = true;
        socketActivation.enable = true;
      };
    };
  };
}

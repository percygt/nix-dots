{
  lib,
  libx,
  username,
  config,
  ...
}: let
  cfg = config.editor;
  modules = [
    ./emacs
    ./vscode
    ./neovim
  ];
  rootDir = builtins.readDir ./.;
in
  libx.importModules {inherit modules cfg rootDir;}
  // {
    options = {
      editor = {
        neovim.enable = lib.mkEnableOption "Enable neovim";
        emacs.enable = lib.mkEnableOption "Enable emacs";
        vscode.enable = lib.mkEnableOption "Enable vscode";
      };
    };
  }

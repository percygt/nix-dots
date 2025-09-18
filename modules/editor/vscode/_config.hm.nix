{
  pkgs,
  config,
  lib,
  inputs,
  homeDirectory,
  ...
}:
let
  g = config._global;
  moduleVscode = "${g.flakeDirectory}/modules/editor/vscode";
in
{
  imports = [ inputs.vscode-server.homeModules.default ];
  config = lib.mkIf config.modules.editor.vscode.enable {
    services.vscode-server = {
      enable = true;
      enableFHS = true;
      installPath = "${homeDirectory}/.vscode";
    };
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhsWithPackages (
        ps: with ps; [
          rustup
          zlib
          openssl.dev
          pkg-config
          zlib
          cmake
          clang

          nil
          nixd
          nixfmt-rfc-style
        ]
      );
      enableUpdateCheck = true;
      mutableExtensionsDir = false;
      enableExtensionUpdateCheck = true;
    };
    xdg = {
      configFile = {
        "Code/User/settings.json".source = lib.mkForce (
          config.lib.file.mkOutOfStoreSymlink "${moduleVscode}/settings.json"
        );
        "Code/User/keybindings.json".source = lib.mkForce (
          config.lib.file.mkOutOfStoreSymlink "${moduleVscode}/keybindings.json"
        );
      };
    };
  };
}

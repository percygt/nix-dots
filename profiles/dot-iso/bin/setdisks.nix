{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (
      writeShellScriptBin "setdisks" ''
      ''
    )
  ];
}

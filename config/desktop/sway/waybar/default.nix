{
  pkgs,
  lib,
  libx,
  config,
  ...
}:
let
  inherit (libx) toRasi mkLiteral;
  waybarRebuild = pkgs.writeShellApplication {
    name = "waybar-rebuild-exec";
    runtimeInputs = [
      pkgs.coreutils-full
      pkgs.systemd
      pkgs.gnugrep
    ];
    text = ''
      status="$(systemctl is-active nixos-rebuild.service || true)"
      if grep -q "inactive" <<< "$status"; then
        printf '{ "text" : "","class":"success"}'
      elif grep -q "active" <<< "$status"; then
        printf '{ "text" : "","class":"ongoing"}'
      elif grep -q "failed" <<< "$status"; then
        printf '{ "text" : "","class":"fail"}'
      fi
    '';
  };
  extraPackages =
    [ waybarRebuild ]
    ++ (with pkgs; [
      coreutils-full
      systemd
      toggle-service
      toggle-sway-window
      foot
    ]);
  waybarWithExtraBin =
    pkgs.runCommand "waybar"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
        meta.mainProgram = "waybar";
      }
      ''
        makeWrapper ${pkgs.stash.waybar}/bin/waybar $out/bin/waybar --prefix PATH : ${lib.makeBinPath extraPackages}
      '';
  waybar_config = import ./config.nix;
in
{
  services.playerctld.enable = true;

  programs.waybar = {
    enable = true;
    package = waybarWithExtraBin;
    style = toRasi (import ./theme.nix { inherit mkLiteral config; }).theme;
    settings = [
      (waybar_config // { output = "HDMI-A-1"; })
      (
        waybar_config
        // {
          ipc = true;
          id = "bar-1";
          output = "eDP-1";
        }
      )
    ];
  };
}

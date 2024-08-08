{
  pkgs,
  lib,
  config,
  ...
}:
let
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
        printf '{ "text" : " ","class":"success"}'
      elif grep -q "active" <<< "$status"; then
        printf '{ "text" : " ","class":"ongoing"}'
      elif grep -q "failed" <<< "$status"; then
        printf '{ "text" : " ","class":"fail"}'
      fi
    '';
  };
  extraPackages =
    [ waybarRebuild ]
    ++ (with pkgs; [
      coreutils-full
      gnugrep
      systemdMinimal
      toggle-service
      toggle-sway-window
      swaynotificationcenter
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
  inherit (config._general) flakeDirectory;
  moduleWaybar = "${flakeDirectory}/config/desktop/sway/waybar";
  c = config.modules.theme.colors.withHashtag;
  f = config.modules.fonts.interface;
  i = config.modules.fonts.icon;
in
{
  services.playerctld.enable = true;
  home.packages = [ waybarWithExtraBin ];

  xdg.configFile = {
    "waybar/config.jsonc" = {
      source = config.lib.file.mkOutOfStoreSymlink "${moduleWaybar}/config.jsonc";
      onChange = ''
        ${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true
      '';
    };
    "waybar/style.css" = {
      source = config.lib.file.mkOutOfStoreSymlink "${moduleWaybar}/style.css";
      onChange = ''
        ${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true
      '';
    };
    "waybar/nix.css".text =
      # css
      ''
        @define-color bg0 ${c.base00};
        @define-color bg1 ${c.base01};
        @define-color bg2 ${c.base02};
        @define-color gr0 ${c.base03};
        @define-color gr1 ${c.base04};
        @define-color grey ${c.base03};
        @define-color border ${c.base05};
        @define-color text-dark ${c.base01};
        @define-color text-light ${c.base07};
        @define-color green ${c.base0B};
        @define-color blue ${c.base0D};
        @define-color red ${c.base08};
        @define-color purple ${c.base0E};
        @define-color orange ${c.base0F};
        @define-color transparent rgba(0,0,0,0);
        * {
          font-family: '${f.name}, ${i.name}';
          font-size: ${toString f.size}px;
          font-weight: 600;
          min-height: 0px;
        }
      '';
  };
}

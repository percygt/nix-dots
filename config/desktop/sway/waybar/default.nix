{
  pkgs,
  lib,
  config,
  ...
}:
let
  nixosRebuild = pkgs.writeShellApplication {
    name = "waybar-rebuild-exec";
    runtimeInputs = [
      pkgs.coreutils-full
      pkgs.systemd
      pkgs.gnugrep
    ];
    text = ''
      status="$(systemctl is-active nixos-rebuild.service || true)"
      if grep -q "inactive" <<< "$status"; then
        printf '{ "text" : "\ueb6d ","class":"success"}'
      elif grep -q "active" <<< "$status"; then
        printf '{ "text" : "\ueb6d ","class":"ongoing"}'
      elif grep -q "failed" <<< "$status"; then
        printf '{ "text" : "\ueb6d ","class":"fail"}'
      fi
    '';
  };
  extraPackages =
    [ nixosRebuild ]
    ++ (with pkgs; [
      coreutils-full
      systemd
      toggle-service
      toggle-sway-window
      swaynotificationcenter
      nixos-rebuild
      wlsunset
      foot
    ]);
  waybarWithExtraPackages =
    pkgs.runCommand "waybar"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
        meta.mainProgram = "waybar";
      }
      ''
        makeWrapper ${pkgs.waybar}/bin/waybar $out/bin/waybar --prefix PATH : ${lib.makeBinPath extraPackages}
      '';
  inherit (config._general) flakeDirectory;
  moduleWaybar = "${flakeDirectory}/config/desktop/sway/waybar";
  c = config.modules.theme.colors.withHashtag;
  f = config.modules.fonts.interface;
  i = config.modules.fonts.icon;
in
{
  services.playerctld.enable = true;
  programs.waybar = {
    enable = true;
    package = waybarWithExtraPackages;
  };
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
        @define-color bg ${c.base00};
        @define-color bg-lighter ${c.base10};
        @define-color bg-darker ${c.base11};
        @define-color bg-alt ${c.base02};
        @define-color grey ${c.base03};
        @define-color grey-alt ${c.base04};
        @define-color border ${c.base03};
        @define-color text-dark ${c.base01};
        @define-color text-light ${c.base05};
        @define-color green ${c.base0B};
        @define-color blue ${c.base0D};
        @define-color red ${c.base08};
        @define-color purple ${c.base0E};
        @define-color orange ${c.base0F};
        @define-color transparent rgba(0,0,0,0);
        @define-color bg-hover rgba(255, 255, 255, 0.1);
        @define-color bg-focus rgba(255, 255, 255, 0.1);
        @define-color bg-close rgba(255, 255, 255, 0.1);
        @define-color bg-close-hover rgba(255, 255, 255, 0.15);
        * {
          font-family: '${f.name}, ${i.name}';
          font-size: ${toString f.size}px;
          font-weight: 600;
          min-height: 0px;
        }
      '';
  };
}
